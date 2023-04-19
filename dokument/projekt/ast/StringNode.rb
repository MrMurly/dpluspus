require './ast/Node'

class StringNode
    def initialize(string)
        @string = string

    end

    def evaluate
        @string
    end 
end