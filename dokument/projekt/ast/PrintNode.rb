require './ast/Node'

##
# A node representing the print function.
#
# When evaluated it prints out the choosen
# object.

class PrintNode < Node

    ##
    # Prints objects described by
    # - obj: an object choosen to be printed.

    def initialize obj
        @obj = obj
    end

    def evaluate
        puts @obj.evaluate
    end
end