require './ast/FuncCallNode'
require './Return'

class ClassMethodCallNode < Node 
    def initialize varname, methodname, parameters=[]
        @varname = varname
        @methodname = methodname
        @parameters = parameters
        @head
    end

    def evaluate
        @head = searchStackFrame(@varname)[:value][:methods][@methodname]
        pushStackFrame
        if @parameters
            parameterSetup
        end
        @@stackframe["this"] = @varname
        if @head[:block].is_a? Node
            begin
                @head[:block].evaluate
            rescue Return => e
                result = e.val
            end
        end
        popStackFrame
        return result
    end


    def parameterSetup
        paramlen = @head[:parameters].length        
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end

        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments but got #{@parameters.length}"
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            paramtype = @head[:parameters][i][:type]
            puts "HAAH #{pm}"
            @@stackframe[@head[:parameters][i][:name]] = pm
            puts @head[:parameters][i][:name], pm
        end
    end
end