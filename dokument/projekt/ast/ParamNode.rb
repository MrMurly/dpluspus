require './ast/Node'

class ParamNode < Node

    def initialize(childs, param)
        @param = childs
        @childs = childs
    end


   # [{...}]

    def evaluate
        if @child.is_a? ParamNode 
            @param = @child.evaluate.concat(@param)
        end
        @param
    end

end


# ParamNode => ParamNode => Node => ... => [{...}]
#
#
#