import networkx as nx
from scfmsp.controlflowanalysis.NetworkXConvert import NetworkXConvert
from scfmsp.controlflowanalysis.Function import Function
from scfmsp.controlflowanalysis.ExecutionPoint import ExecutionPoint


class Program:
    def __init__(self):
        self.functions = {}
        self.functions_with_callers = {}
        self.entry_point: ExecutionPoint = None
        self.possible_exit_points = []
        self.exit_point = None

        self.graph = None

    def add_function(self, function: Function):
        self.functions.update({
            function.name: function
        })

    def set_entry_point(self, ep: ExecutionPoint):
        if self.entry_point == ep:
            return
        self.entry_point = ep

        conv = NetworkXConvert(self)
        self.graph = conv.create_graph_from(ep)

    def get_exit_point(self) -> ExecutionPoint:
        return self.exit_point

    def get_instruction_at_execution_point(self, ep: ExecutionPoint):
        if ep.has_caller():
            key = ep.caller
            if key not in self.functions_with_callers.keys():
                inst = self.functions[ep.function].get_for_caller(ep.caller)
                self.functions_with_callers[key] = inst
            return self.functions_with_callers[key].instructions[ep]
        else:
            try:
                return self.functions[ep.function].instructions[ep]
            except KeyError as ke:
                raise ke
