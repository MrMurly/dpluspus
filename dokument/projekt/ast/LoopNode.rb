require './ast/Node'

class LoopNode < Node

    def initialize(var, addition, boolean, block)
        @var = var
        @addition = addition
        @boolean = boolean
        @block = block
    end

    def evaluate
        if @var
            @var.evaluate
            
        end

        while @boolean.evaluate[:value]
            val = @block.evaluate
            #puts val
            if @addition
                @addition.evaluate
            end            
        end

        return val
    end

end