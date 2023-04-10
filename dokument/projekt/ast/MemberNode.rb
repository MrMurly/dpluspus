require './ast/Node'

class MemberNode < Node

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