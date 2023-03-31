require './ast/Node'

class VariableNode < Node
    def initialize name
      @name = name
    end
  
    def evaluate
      searchStackFrame @name
    end
end