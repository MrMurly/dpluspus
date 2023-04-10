require './ast/Node'

class ClassBlockVarNode < Node
    def initialize primitive, name, block
        @primitive = primitive
        @name = name
        @block = block
    end

    def evaluate
        # do something with this....

        if @block
            @block.evaluate
        end

    end
end