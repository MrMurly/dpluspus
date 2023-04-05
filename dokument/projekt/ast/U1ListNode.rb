require './ast/Node'

class ListNode < Node
    
    def initialize(listType, name, members)
        @listType = listType
        @name = name
        @members = members
    end

    def evaluate
        begin
            #p "M1 #{@members}"
            if @members

                @members = @members.evaluate

                @members.map!(&:evaluate)

                for member in @members
                    if member[:type] != @listType
                        raise "List must only contain members of the type #{@listType}!"
                    end
                end
            else
                @members = []
            end
            #p "M2 #{@members}"

            @@stackframe[@name] = {
                :type => @listType,
                :list => @members
            }
        end
    end
end