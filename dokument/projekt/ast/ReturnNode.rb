require './ast/Node'
require './Return'

##
# a node representing a return call from a function.
# e.g. return foo;
#
# When evaluated, raises an error which is caught in the 
# FunctionCall Node.

class ReturnNode 

    ##
    # Creates a new ReturnNode described by:
    # - val: an expression which returns a value
    #       to be returned.
    
    def initialize(val)
        @val = val
    end

    def evaluate
        raise Return.new @val.evaluate
    end
end