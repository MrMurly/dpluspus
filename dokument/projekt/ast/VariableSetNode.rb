require './ast/Node'

class VariableSetNode < Node
    def initialize name, type, expression
      @name = name
      @expression = expression
      @type = type
    end
  
    def evaluate
      begin
        expression = @expression.evaluate

        if @type != expression[:type]
          raise "types don't match!"
          return
        end

        @@stackframe[@name] = {:value => expression[:value], :type => @type}

      # rescue Exception => e 
      #   puts e.message
      end
              
      #@@stackframe[@name] = {:value => expression[:value], :type => @type}
    end
end