# Kickstart tests

[Kickstart tests](https://github.com/rhinstaller/kickstart-tests) plugin runs [launcher](https://github.com/rhinstaller/kickstart-tests/blob/master/containers/runner/launch) in a single workflow. The launcher runs batch of tests in a container. Each test is an installation in a KVM virtual machine. Tests are run concurrently on several machines in the container. The workflow is parsing output of the launcher to update the results of individual tests.

# Configuration

The parameters passed to the launcher come from these sources:

- Test library
  - Set of tests to be run is defined by test cases selected based on the event.
  - The kickstart test corresponding to the [tclib](https://github.com/rhinstaller/tclib) test case is defined by `execution.automation_data.test` parameter.
  - Examples: [basic](../../../tests/test_library/kickstart-test/basic), [scenarios](../../../tests/test_library/kickstart-test/scenarios)

- Settings
  - Modify these launcher options: `--timeout`, `--retry`
  - See the default [settings](settings.ini).

- Event
  - Example:

```
{
  'type' : 'github.scheduled.daily.kstest',
  'bootIso': {
    'x84_64': 'file:///testing.boot.iso'
  }
  'scenario' : {
    'testplan' : 'minimal',
    'platform' : 'fedora',
    'installation_tree' : 'http://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/x86_64/os/'
  }
}
```
  - `bootIso.x86_64`: installer boot.iso to be tested
  - `scenario.testplan`: specifies the test plan (batch of tests) to be run
  - `scenario.platform`: specifies platform for the launcher (`--platform` and `--defaults` options)
  - `scenario.installation_tree`: installation tree to be used, if `bootIso` structure is not defined boot.iso is fetched from the tree

# Examples

The `tclib` library has to be cloned to run the tests.

    git clone https://github.com/rhinstaller/tclib

Example: dry run (just echoes the launcher call) using dummy boot.iso:

    touch boot.iso
    PYTHONPATH=${PYTHONPATH:-}:${PWD}/tclib ./pipeline --debug-log pipeline-debug.log --override library.directPath=./tests/test_library/kickstart-test/results_parsing --override kickstart_test.timeout=10m --override workflows.dry_run=True run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///'${PWD}'/boot.iso"}}'

Example: real run with single test `container`:

    PYTHONPATH=${PYTHONPATH:-}:${PWD}/tclib ./pipeline --debug-log pipeline-debug.log --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.timeout=20m run_event '{"type": "kstest-poc",  "bootIso": {"x86_64":"http://dl.fedoraproject.org/pub/fedora/linux/releases/35/Everything/x86_64/os/images/boot.iso"}}'

Example: dry scenario run using dummy boot.iso:

    touch boot.iso
    PYTHONPATH=${PYTHONPATH:-}:${PWD}/tclib ./pipeline --debug-log pipeline-debug.log --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"platform": "rhel9", "testplan": "rhel9", "installation_tree": "http://download.com/rhel-9/compose/BaseOS/x86_64/os"} }'

If we didn't define the dummy boot.iso in `bootIso`, it would be fetched from the `installation_tree` location.
