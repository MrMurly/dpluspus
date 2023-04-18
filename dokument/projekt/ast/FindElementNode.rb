require './ast/Node'

class FindElementNode < Node
    def initialize(listName, index)
        @listName = listName
        @index = index
    end

    def evaluate
        @index = @index.evaluate[:value]
        list = searchStackFrame(@listName)[:list]
        begin
            if @index <= 0 || @index > list.length
                raise "index: #{@index} out of bounds of list length"
            end
        end
        element = list[@index - 1]

        #puts element
        element
    end
end