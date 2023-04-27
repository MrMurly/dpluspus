require './ast/Node'

class MemberNode < Node

    def initialize(current, child)
        @current = current
        @child = child
    end

    def evaluate
        puts "member #{@current}"
        if @child
            if @current.is_a? MemberNode
                # p @current.evaluate
                # p @child
                @current = @current.evaluate.concat(@child)
            end
        end
        #p @current
        @current
    end
end