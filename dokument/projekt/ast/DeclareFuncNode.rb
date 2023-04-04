require './ast/Node'

class DeclareFuncNode < Node

    def initialize( returnType, name, parameters, block)
        @returnType = returnType
        @name = name
        @parameters = parameters
        @block = block
    end

    def evaluate
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end
        @@stackframe[@name] = {
            :returnType => @returnType,
            :parameters => @parameters,
            :block => @block
        }
    end

end