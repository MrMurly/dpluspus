require './ast/Node'

##
# A node representing all elements in the list.
#
# Once evaluated returns a combined ruby array of
# all the list elements. 

class MemberNode < Node

    ##
    # Creates a new Memberlist described by
    # - current: An array containing only the first element 
    # - child: An array containing one of the other elements
    #       in the list.

    def initialize(current, child)
        @current = current
        @child = child
    end

    def evaluate
        if @child
            if @current.is_a? MemberNode
                @current = @current.evaluate.concat(@child)
            end
        end
        @current
    end
end