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

      @@stackframe[@name] = {:value => expression[:value], :type => @type}
    end
end