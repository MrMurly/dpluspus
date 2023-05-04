require './ast/Node'

##
# A node that finds a specified element of
# a list.
#
# When evaluated the node returns the element
# of the specified index.


class FindElementNode < Node

    ##
    # Finding an element by index described by
    # - listname: the name of the list containing 
    #       wanted element.
    # - index: an Integer that represents the location of 
    #       the element.

    def initialize(listName, index)
        @listName = listName
        @index = index
    end

    def evaluate
        @index = @index.evaluate[:value]
        list = searchStackFrame(@listName)[:value]
        begin
            if @index <= 0 || @index > list.length
                raise "index: #{@index} out of bounds of list length"
            end
        end
        element = list[@index - 1]

        element
    end
end