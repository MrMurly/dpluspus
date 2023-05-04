require './ast/Node'

##
# A node representing the list
#
# when evaluated it will return either
# a list represented by a variable name
# or just the list


class ListNode < Node
    
    ##
    # Creates a new list described by
    # - listType: what datatype the list contains
    # - name: the name of the list
    # - members: a hash containing a ruby array and 
    #       the datatype of the elements it contains.

    def initialize(listType, name, members)
        @listType = listType
        @name = name
        @members = members
    end

    def evaluate 
        if @members

            @members = @members.evaluate

            if @listType
                for member in @members[:value]
                    if member[:type] != @listType
                        raise "List must only contain
                        members of the type #{@listType}!"
                    end
                end
            end
        else
            @members = {:type => @listType, :value => []}
        end
    
        if @listType && @name
            @@stackframe[@name] = @members
            
        else
            @members
        end
    end
end