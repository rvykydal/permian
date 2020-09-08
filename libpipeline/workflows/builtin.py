from .isolated import IsolatedWorkflow
from .factory import WorkflowFactory
from ..exceptions import UnexpectedState

@WorkflowFactory.register(None)
class UnknownWorkflow(IsolatedWorkflow):
    """
    This workflow is used when the workflow name in caseRunConfiguration has no
    corresponding workflow.

    The purpose of this workflow is to report error during execution.
    """
    def run(self):
        self.reportResult(...) # TODO: report error signaling unknown workflow

    def terminate(self):
        raise UnexpectedState("It shouldn't be possible to terminate this workflow as it should never run")

    def execute(self):
        pass

    def displayStatus(self):
        return 'Unknown workflow!'

@WorkflowFactory.register('manual')
class ManualWorkflow(IsolatedWorkflow):
    """
    This workflow is used for manual testcases, it doesn't do anything
    """
    def terminate(self):
        return False

    def execute(self):
        # TODO: set status
        pass

    def displayStatus(self):
        return 'Nothing to do'
