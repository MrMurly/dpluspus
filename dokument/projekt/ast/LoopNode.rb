require './ast/Node'

##
# A node representing for- and while-loop.
#
# When evaluated the node proceeds to loop the 
# block with a while loop until conditions are met.

class LoopNode < Node

    ##
    # for-loop described by
    # - var: a declared variable.
    # - addition: an arithmetic expression that 
    #       adds 1 to var.
    # - boolean: Logical expression that represents
    #       how many repetitions there are.
    # - block: block of code that is to be repeated
    #
    # while-loop described by
    # - boolean: Logical expression that represents
    #       the criteria that needs to be true for the loop
    #       to continue.
    # - block: Code that is to be repeated.

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
            if @addition
                @addition.evaluate
            end            
        end

        return val
    end

end