require './ast/Node'

class CharacterNode
    def initialize(first, rest)
        @first = first
        @rest = rest
    end

    def evaluate
        if @rest
            if @first.is_a? CharacterNode
            @first = @fist.evaluate.concat(@rest)
            end
        end
        @first
    end

end