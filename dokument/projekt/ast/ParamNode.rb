require './ast/Node'

class ParamNode < Node

    def initialize(childs, param)
        @childs = childs
        @param = param
    end


   # [{...}]

    def evaluate
        if @childs.is_a? ParamNode 
            @param += @childs.evaluate
        end
        @param
    end

end


# ParamNode => ParamNode => Node => ... => [{...}]
#
#
#