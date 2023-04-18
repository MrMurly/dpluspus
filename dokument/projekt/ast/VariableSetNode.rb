require './ast/Node'

class VariableSetNode < Node
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