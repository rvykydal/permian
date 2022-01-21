import logging
import tempfile
import subprocess
import os
import stat
import shutil
import requests
import itertools
from collections import namedtuple

from libpermian.plugins import api
from libpermian.workflows.isolated import GroupedWorkflow
from libpermian.events.base import Event
from libpermian.events.structures.builtin import OtherStructure
from libpermian.result import Result

LOGGER = logging.getLogger(__name__)

BOOT_ISO_RELATIVE_PATH = 'data/images/boot.iso'
BOOT_ISO_PATH_IN_TREE = 'images/boot.iso'

PlatformArguments = namedtuple('PlatformArguments', ['platform', 'defaults'])
PLATFORM_ARGUMENTS = {
    "rhel8": PlatformArguments("rhel8", "scripts/defaults-rhel8.sh"),
    "rhel9": PlatformArguments("rhel9", "scripts/defaults-rhel9.sh"),
}
DEFAULT_DEFAULTS_FILE = "scripts/defaults.sh"


class KicstartTestBatchCurrentResults():
    """Container for storing individual results of kickstart tests run in a batch.

    The results are parsed from output of kickstart tests launcher running
    the batch of kickstart tests.

    :param tests: list of kickstart tests run in the batch
    :type tests: list of str
    :param retry: are the tests retried after the first failure ?
    :type retry: bool
    """
    def __init__(self, tests, retry=True):
        self.results = {test: [] for test in tests}
        self.retry = retry

    def process_output_line(self, line):
        """Update the results from a line of tests launcher output.

        :param line: a line of output from kickstart tests launcher
        :type line: str
        :return: tuple containing name of the finished test and its result if
                 the line indicates such or (None, None)
        :rtype: (str, libpermian.result.Result)
        """
        finished_test, permian_result = None, None
        if line.startswith("INFO: RESULT:"):
            fields = line.split(":", 5)
            if len(fields) != 6:
                LOGGER.warning("Workflow is not able to parse result from output")
                return (None, None)
            _, _, test, _, result, detail = fields
            if test in self.results:
                self.results[test].append((result, detail))
                finished_test = test
                permian_result = self._get_permian_result_of_test(finished_test)
            else:
                LOGGER.warning("Found result of unexpected test %s", test)

        return (finished_test, permian_result)

    def _get_permian_result_of_test(self, test):
        """Get Permian Result of results stored for the kickstart test.

        :param test: name of the tests to get the result of
        :type test: str
        :return: result corresponding to the results stored for the kickstart test
        :rtype: libpermian.result.Result
        """
        state, result, final = None, None, False

        test_results = self.results.get(test, None)
        if not test_results:
            return Result(state, result, final)

        state, final = "complete", True
        test_result, _result_detail = test_results[-1]
        if test_result == "SUCCESS":
            result = "PASS"
        elif test_result == "FAILED":
            result = "FAIL"

        # retry on flake
        if self._is_flake(test_results):
            state, result, final = "running", None, False

        return Result(state, result, final, partial=self)

    def _is_flake(self, test_results):
        """Are the results qualified as a flake?

        A flake is a failed test which will be re-run (based on launcher option --retry).
        """
        return self.retry and len(test_results) == 1 and test_results[0][0] == "FAILED"

    def summary_message(self):
        """Create a message summarizing current results of the batch test.

        :return: message with test results summary
        :rtype: str
        """
        success = failed = timed_out = flakes = 0
        for test, results in self.results.items():
            if not results:
                continue
            # If the current result of the test is a flake
            if self._is_flake(results):
                flakes += 1
            else:
                final_result = results[-1]
                result, detail = final_result
                if result == "SUCCESS":
                    success += 1
                    flakes += len(results) - 1
                elif result == "FAILED":
                    failed += 1

        all_results = list(itertools.chain.from_iterable(self.results.values()))
        timed_out = sum([1 for result, detail in all_results
                         if result == "FAILED" and detail == "Test timed out"])
        n_a = len(self.results) - success - failed

        return f"SUCCESS: {success} FAILED: {failed} N/A: {n_a} (runs: {len(all_results)} flakes: {flakes} timed out: {timed_out})"

    def get_test_results(self, test):
        try:
            return self.results[test]
        except KeyError:
            LOGGER.warning("Found result of unexpected test %s", test)
            return None


@api.events.register_structure('bootIso')
class BootIsoStructure(OtherStructure):
    pass


@api.events.register_structure('scenario')
class ScenarioStructure(OtherStructure):
    pass


@api.workflows.register("kickstart-test")
class KickstartTestWorkflow(GroupedWorkflow):

    @classmethod
    def factory(cls, testRuns, crcList):
        cls(testRuns, crcList)

    def __init__(self, testRuns, crcList):
        super().__init__(testRuns, crcList)
        self.ksrepo_dir = None
        self.ksrepo_local_dir = self.settings.get('kickstart_test', 'kstest_local_repo')
        self.boot_iso_url = None
        # The path of boot.iso expected by runner
        self.boot_iso_dest = None
        self.runner_command = self.settings.get('kickstart_test', 'runner_command').split()
        self.ksrepo = self.settings.get('kickstart_test', 'kstest_repo')
        self.ksrepo_branch = self.settings.get('kickstart_test', 'kstest_repo_branch')
        self.retry = self.settings.getboolean('kickstart_test', 'retry_on_failure')
        if self.retry:
            self.runner_command.append("--retry")
        self.defaults_file_path = ""

    def setup(self):
        if self.event.bootIso:
            self.boot_iso_url = self.event.bootIso['x86_64']

        self.groupReportResult(self.crcList, Result('queued'))

        if self.ksrepo_local_dir:
            self.ksrepo_dir = self.ksrepo_local_dir
            LOGGER.info("Using existing kickstart-tests repository %s.", self.ksrepo_local_dir)
        else:
            self.ksrepo_dir = os.path.join(tempfile.mkdtemp(), "kickstart-tests")
            LOGGER.info("Created kickstart-tests repository directory %s", self.ksrepo_dir)
            LOGGER.info("Cloning kickstart-tests repository %s branch %s.",
                        self.ksrepo, self.ksrepo_branch)

            subprocess.run(
                ['git',
                 'clone',
                 self.ksrepo,
                 self.ksrepo_dir,
                 '--branch',
                 self.ksrepo_branch,
                 ],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
            )

        command_args, defaults_file_path, tree_boot_iso_url = self.process_scenario(
            self.event.scenario
        )
        self.runner_command.extend(command_args)
        self.defaults_file_path = defaults_file_path
        self.boot_iso_url = self.boot_iso_url or tree_boot_iso_url

        self.boot_iso_dest = os.path.join(self.ksrepo_dir, BOOT_ISO_RELATIVE_PATH)

        if self.boot_iso_url:
            LOGGER.info("Fetchig installer boot.iso %s", self.boot_iso_url)
            self.fetch_boot_iso(self.boot_iso_url, self.boot_iso_dest)
        else:
            LOGGER.info("Default rawhide installer boot.iso will be fetched.")

    def process_scenario(self, scenario):
        """Get test parameters from scenario event structure

        :param scenario: structure holding scenario data
        :type scenario: ScenarioStructure
        :returns: tuple with
                  - list of additional launcher arguments
                  - path of tenmporary override defaults file to be used by launcher
                  - boot.iso url based on installation tree location
        :rtype: (list(str), str, str))
        """
        tree_boot_iso_url = None
        command_args = []

        installation_tree = None
        platform = None
        if scenario:
            try:
                installation_tree = scenario['installation_tree']
            except KeyError:
                pass
            try:
                platform = scenario['platform']
            except KeyError:
                pass

        defaults_file = DEFAULT_DEFAULTS_FILE
        if platform in PLATFORM_ARGUMENTS:
            command_args.extend(["--platform", PLATFORM_ARGUMENTS[platform].platform])
            defaults_file = PLATFORM_ARGUMENTS[platform].defaults

        defaults_file_path = self._create_override_defaults_file(defaults_file, installation_tree)
        command_args.extend(["--defaults", defaults_file_path])

        if installation_tree:
            tree_boot_iso_url = os.path.join(installation_tree, BOOT_ISO_PATH_IN_TREE)

        return (command_args, defaults_file_path, tree_boot_iso_url)

    def _create_override_defaults_file(self, defaults_file, installation_tree):
        with tempfile.NamedTemporaryFile("w", delete=False, prefix="defaults-") as f:
            content = "# Defaults file overriding the sourced one"
            # source the overriden file
            content += f"\nsource {defaults_file}"
            # override defaults
            if installation_tree:
                content += f"\nKSTEST_URL={installation_tree}"

            fpath = f.name
            LOGGER.info(f"Using override defaults file {fpath}:\n{content}")
            f.write(content)

        os.chmod(fpath, os.stat(fpath).st_mode | stat.S_IROTH)
        return fpath

    @staticmethod
    def fetch_boot_iso(iso_url, dest):
        """Fetch boot.iso."""
        iso_dir = os.path.dirname(dest)
        if not os.path.isdir(iso_dir):
            os.makedirs(iso_dir, 0o755, exist_ok=True)
            LOGGER.debug("Created %s", iso_dir)

        if iso_url.startswith("http://"):
            with requests.get(iso_url, stream=True, allow_redirects=True) as r:
                with open(dest, 'wb') as f:
                    shutil.copyfileobj(r.raw, f)

        elif iso_url.startswith("file://"):
            shutil.copyfile(iso_url[7:], dest)

    @staticmethod
    def _get_test_from_crc(crc):
        return crc.testcase.execution.automation_data['test']

    @classmethod
    def _map_tests_to_crcs(cls, crclist):
        result = {}
        for crc in crclist:
            test = cls._get_test_from_crc(crc)
            try:
                result[test].append(crc)
            except KeyError:
                result[test] = [crc]
        return result

    def execute(self):
        self.groupReportResult(self.crcList, Result('started'))

        test_to_crcs = self._map_tests_to_crcs(self.crcList)
        tests = list(test_to_crcs.keys())
        current_results = KicstartTestBatchCurrentResults(tests, retry=self.retry)
        self.groupReportResult(self.crcList, Result('running', current_results=current_results))

        command = self.runner_command + tests
        LOGGER.debug("Number of kickstart tests to be run: %d", len(tests))
        LOGGER.info("Running %s", command)
        with subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            bufsize=1,
            universal_newlines=True,
            cwd=self.ksrepo_dir,
        ) as p:
            for line in p.stdout:
                line = line.strip()
                # TODO: make this configurable in settings
                LOGGER.info("[runner] %s", line.strip())
                finished_test, result = current_results.process_output_line(line)
                if finished_test:
                    self.groupReportResult(test_to_crcs[finished_test], result)
                    LOGGER.info(f"Test {finished_test} finished. {current_results.summary_message()}")

    def dry_execute(self):
        self.runner_command = ['echo'] + self.runner_command
        self.execute()

    def teardown(self):
        if self.boot_iso_url:
            LOGGER.info("Removing installer boot.iso.")
            try:
                os.remove(self.boot_iso_dest)
            except FileNotFoundError:
                LOGGER.debug("Installer boot.iso %s not found", self.boot_iso_dest)

        if self.defaults_file_path:
            os.unlink(self.defaults_file_path)

        if not self.ksrepo_local_dir:
            tempdir = os.path.normpath(os.path.join(self.ksrepo_dir, '..'))
            LOGGER.info("Removing %s with kickstart-tests repo.", tempdir)
            shutil.rmtree(tempdir)

    def groupTerminate(self, crcIds):
        LOGGER.info('Something attempted to stop me!')
        return False

    def groupDisplayStatus(self, crcId):
        status = ""
        current_results = self.crcList[crcId].result.extra_fields.get('current_results')
        if current_results:
            test = self._get_test_from_crc(self.crcList[crcId])
            test_results = current_results.get_test_results(test)
            if test_results:
                status = f"{test_results}"
        return status
