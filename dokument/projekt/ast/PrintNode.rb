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
        val = @obj.evaluate[:value]

        if val.is_a? Array 
            print "["
            for i in 0...val.length do
                print val[i][:value]
                if i != val.length - 1
                    print ", "
                end
            end
            print "]\n"
        else
            puts val
        end
    end
end