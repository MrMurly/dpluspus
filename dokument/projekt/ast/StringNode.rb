require './ast/Node'

class StringNode
    def initialize(string)
        @characters = string
        @string = ""
    end

    def evaluate
        @characters = @characters.evaluate

        for char in @characters
            @string += char.evaluate
        end
        @string
    end 
end