require './ast/Node'

##
# A node representing declaration of
# variables
#
# When evaluated, adds the variable as a key 
# to the stackframe with a hash with the object and 
# type represented by that key.



class VariableSetNode < Node

  ##
  # The declaration of variables described by
  # - name: name of the variable.
  # - expression: the value the variable is given.
  # - type: what datatype the variable is.

    def initialize name, type, expression
      @name = name
      @expression = expression
      @type = type
    end
  
    def evaluate
      expression = @expression.evaluate
      if @type != expression[:type]
        raise "type #{@type} and #{expression[:type]}"
        return
      end
      if expression.key? :value
        expression = expression[:value]
      end
      @@stackframe[@name] = {:value => expression, :type => @type}
    end
end