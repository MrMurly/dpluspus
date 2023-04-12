require './ast/Node'

class FindElementNode < Node
    def initialize(listName, index)
        @listName = listName
        @index = index
    end

    def evaluate
        @index = @index.evaluate[:value]
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        element = searchStackFrame(@listName)[:list][@index - 1]

        element
    end
end