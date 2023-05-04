require './ast/Node'

##
# A node that represents assigning new values
# to already declared variables.
#
# When evaluated the existign variable in the 
# stackframe will receive the new specified value.


class VariableAssignmentNode < Node

  ##
  # Variable assignment described by
  # - name: name of already existing variable.
  # - expression: the new value which will be assigned
  #       to the old variable.

    def initialize name, expression
      @name = name
      @expression = expression
    end
  
    def evaluate
      modifyStackFrame @name, @expression.evaluate
    end
  
end