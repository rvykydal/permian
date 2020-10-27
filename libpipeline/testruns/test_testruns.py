import unittest
from tclib import library
from libpipeline.settings import Settings
from libpipeline.events.base import Event
from libpipeline.workflows.factory import WorkflowFactory
from libpipeline.workflows.isolated import IsolatedWorkflow, GroupedWorkflow
from libpipeline.workflows.builtin import UnknownWorkflow, ManualWorkflow
from libpipeline.testruns import CaseRunConfiguration, CaseRunConfigurationsList, TestRuns, merge_testcase_configurations
from libpipeline.result import Result


class TestWorkflowIsolated(IsolatedWorkflow):
    def execute(self):
        pass

    def terminate(self):
        return False

    def displayStatus(self):
        return 'Test'


class TestWorkflowGroupedAll(GroupedWorkflow):
    def execute(self):
        pass

    def groupTerminate(self):
        return False

    def groupDisplayStatus(self):
        return 'Test'

    @classmethod
    def factory(cls, testRuns, crcIds):
        cls(testRuns, crcIds)


class TestWorkflowGrouped(GroupedWorkflow):
    def execute(self):
        pass

    def groupTerminate(self):
        return False

    def groupDisplayStatus(self):
        return 'Test'

    @classmethod
    def factory(cls, testRuns, crcIds):
        # Split caseruns into groups by architecture
        groups_by_config = dict()
        for crcId in crcIds:
            caserun = testRuns[crcId]
            try:
                groups_by_config[caserun.configuration['arch']].append(crcId)
            except KeyError:
                groups_by_config[caserun.configuration['arch']] = [crcId]

        for crcIds in groups_by_config.values():
            cls(testRuns, crcIds)


def testruns_init():
        lib = library.Library('tests/test_library')
        settings = Settings(cmdline_overrides={'library': {'defaultCaseConfigMergeMethod': 'extension'}}, environment={}, settings_locations=[])
        event = Event('test', {}, ['test_workflows'])
        return TestRuns(lib, event, settings)


class TestCaseRunConfigurationsList(unittest.TestCase):
    def test_caserun_configurations_list(self):
        caserun_configurations = CaseRunConfigurationsList()
        caserun_configurations.append(1)
        self.assertListEqual(caserun_configurations, [1])
        caserun_configurations.append(1)
        self.assertListEqual(caserun_configurations, [2])
        caserun_configurations.append(3)
        self.assertListEqual(caserun_configurations, [2, 3])


class TestAssignWorkflows1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        WorkflowFactory.clear_workflow_classes()
        WorkflowFactory.register('test_isolated')(TestWorkflowIsolated)
        WorkflowFactory.register('test_grouped')(TestWorkflowGroupedAll)
        cls.testruns = testruns_init()

    @classmethod
    def tearDownClass(cls):
        WorkflowFactory.restore_workflow_classes()

    def test_isolated(self):
        for caserun in self.testruns.caseRunConfigurations:
            if caserun.testcase.name == 'test_isolated 1':
                workflow1 = caserun.workflow
            if caserun.testcase.name == 'test_isolated 2':
                workflow2 = caserun.workflow

        self.assertIsInstance(workflow1, TestWorkflowIsolated)
        self.assertIsInstance(workflow2, TestWorkflowIsolated)
        self.assertNotEqual(workflow1, workflow2)

    def test_grouped_all(self):
        for caserun in self.testruns.caseRunConfigurations:
            if caserun.testcase.name == 'test_grouped 1':
                workflow1 = caserun.workflow
            if caserun.testcase.name == 'test_grouped 2':
                workflow2 = caserun.workflow
            if caserun.testcase.name == 'test_grouped 3':
                workflow3 = caserun.workflow

        self.assertIsInstance(workflow1, TestWorkflowGroupedAll)
        self.assertIsInstance(workflow2, TestWorkflowGroupedAll)
        self.assertIsInstance(workflow3, TestWorkflowGroupedAll)
        self.assertEqual(workflow1, workflow2)
        self.assertEqual(workflow2, workflow3)

    def test_manual(self):
        for caserun in self.testruns.caseRunConfigurations:
            if caserun.testcase.name == 'testcase 1':
                workflow = caserun.workflow

        self.assertIsInstance(workflow, ManualWorkflow)

    def test_unknown(self):
        for caserun in self.testruns.caseRunConfigurations:
            if caserun.testcase.name == 'testcase 2':
                workflow = caserun.workflow

        self.assertIsInstance(workflow, UnknownWorkflow)


class TestAssignWorkflows2(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        WorkflowFactory.clear_workflow_classes()
        WorkflowFactory.register('test_grouped')(TestWorkflowGrouped)
        cls.testruns = testruns_init()

    @classmethod
    def tearDownClass(cls):
        WorkflowFactory.restore_workflow_classes()

    def test_grouped_by_config(self):
        for caserun in self.testruns.caseRunConfigurations:
            if caserun.testcase.name == 'test_grouped 1':
                workflow1 = caserun.workflow
            if caserun.testcase.name == 'test_grouped 2':
                workflow2 = caserun.workflow
            if caserun.testcase.name == 'test_grouped 3':
                workflow3 = caserun.workflow

        self.assertIsInstance(workflow1, TestWorkflowGrouped)
        self.assertIsInstance(workflow2, TestWorkflowGrouped)
        self.assertIsInstance(workflow3, TestWorkflowGrouped)
        self.assertEqual(workflow1, workflow2)
        self.assertNotEqual(workflow2, workflow3)


class DummyTestCase():
    def __init__(self, name):
        self.name = name
        self.execution = {'type': 'test'}


class TestMerge_testcase_configurations(unittest.TestCase):
    def setUp(self):
        self.caseRunConfigurations = [CaseRunConfiguration(DummyTestCase('testcase1'), {'conf': 1}, []),
                                      CaseRunConfiguration(DummyTestCase('testcase1'), {'conf': 2}, []),
                                      CaseRunConfiguration(DummyTestCase('testcase2'), {'conf': 3}, []),
                                      CaseRunConfiguration(DummyTestCase('testcase2'), {'conf': 4}, [])]

    def test_common_result(self):
        self.caseRunConfigurations[0].result = Result('running', 'PASS', False, self.caseRunConfigurations[0])
        self.caseRunConfigurations[1].result = Result('complete', 'FAIL', False, self.caseRunConfigurations[1])
        testcases = merge_testcase_configurations(self.caseRunConfigurations)

        self.assertEqual(testcases['testcase1']['result'].state, 'running')
        self.assertEqual(testcases['testcase1']['result'].result, 'FAIL')
        self.assertEqual(testcases['testcase2']['result'].state, 'not started')
        self.assertEqual(testcases['testcase2']['result'].result, None)
        #print()

    def test_common_workflow(self):
        testcases = merge_testcase_configurations(self.caseRunConfigurations)
        self.assertEqual(testcases['testcase1']['workflow'], 'test')

    def test_configurations(self):
        testcases = merge_testcase_configurations(self.caseRunConfigurations)
        self.assertEqual(len(testcases['testcase1']['caseRunConfigurations']), 2)
        self.assertEqual(testcases['testcase1']['caseRunConfigurations'][0].configuration['conf'], 1)
        self.assertEqual(testcases['testcase1']['caseRunConfigurations'][1].configuration['conf'], 2)
        self.assertEqual(len(testcases['testcase2']['caseRunConfigurations']), 2)
        self.assertEqual(testcases['testcase2']['caseRunConfigurations'][0].configuration['conf'], 3)
        self.assertEqual(testcases['testcase2']['caseRunConfigurations'][1].configuration['conf'], 4)
