require './ast/ClassBlockNode'

class ClassConstructorNode < ClassBlockNode
    def initialize classname, parameters=[], block
        @classname = classname
        @parameters = parameters
        @block = block
    end

    def evaluate
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end
        return {
            :type => "constructor",
            :parameters => @parameters,
            :block => @block
        }
    end
end