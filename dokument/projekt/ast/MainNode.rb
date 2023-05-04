require './ast/Node'

##
# The topmost node of the tree, containing both
# main function, which is the start of every 
# program, but also the next node, which can be
# a function or class node.

class MainNode < Node 

    ##
    # Creates a new MainNode described by:
    # - other: a function or class definition Node
    # - nxt: can be the main function or another main Node.
    
    def initialize(other, nxt)
        @other = other
        @nxt = nxt
    end

    def evaluate 
        @other.evaluate
        @nxt.evaluate
    end
end