
require './ast/Node'

class VariableAssignmentNode < Node
    def initialize name, expression
      @name = name
      @expression = expression
    end
  
    def evaluate
      modifyStackFrame @name, @expression.evaluate
    end
  
end