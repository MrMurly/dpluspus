require './ast/Node'

class ClassBlockFuncNode < Node
    def initialize function, block
        @function = function
        @block = block
    end

    def evaluate
        @funciton.evaluate
        @block.evaluate
    end
end