require './ast/Node'

##
# A node representing an existing variable in the stackframe.
#
# When evaluated, returns the existing variable from 
# the stackframe.

class VariableNode < Node

  ##
  # Variable described by
  # - name: the name of the variable

    def initialize name
      @name = name
    end
  
    def evaluate
      searchStackFrame @name
    end
end