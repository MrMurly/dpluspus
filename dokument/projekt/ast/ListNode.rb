require './ast/Node'

class ListNode < Node
    
    def initialize(listType, name, members)
        @listType = listType
        @name = name
        @members = members
    end

    def evaluate
        begin
            if @members

                @members = @members.evaluate

                if @listType
                    for member in @members[:value]
                        if member[:type] != @listType
                            raise "List must only contain members of the type #{@listType}!"
                        end
                    end
                end
            else
                @members = {:type => @listType, :value => []}
            end
        
            if @listType && @name
                @@stackframe[@name] = {
                    :type => @listType,
                    :list => @members
                }
            else
                @members
                # @listType = @members[0][:type]

                # @@stackframe["noNameList"] = {
                #     :type => @listType,
                #     :value => @members} 

            end
            #print searchStackFrame(@name)
        end
    end
end