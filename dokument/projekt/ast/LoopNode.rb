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
            @block.evaluate
            if @addition
                @addition.evaluate
            end            
        end
    end

end