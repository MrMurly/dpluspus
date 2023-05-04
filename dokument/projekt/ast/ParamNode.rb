require './ast/Node'

##
# A node representing parameters for a function.
#
# When evaluated, returns an array containing all the
# parameters.

class ParamNode < Node

    ##
    # Parameters described by
    # - childs: points towards next parameters 
    # - param: The value which the parameters has 

    def initialize(childs, param)
        @childs = childs
        @param = param
    end

    def evaluate
        if @childs.is_a? Array
            @param += @childs
        end
        @param
    end

end
