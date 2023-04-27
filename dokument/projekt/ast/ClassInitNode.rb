require './ast/Node'

class ClassInitNode < Node

    def initialize(classname, parameters)
        @classname = classname
        @parameters = parameters
    end

    def evaluate
        @head = searchStackFrame(@classname)
        pushStackFrame
        if @parameters
            parameterSetup
        end
        @@stackframe["this"] = "temp" 
        @@stackframe["temp"] = {:value => @head, :type => @classname }
        if @head[:constructor][:block].is_a? Node
            @head[:constructor][:block].evaluate
        end
        @head = @@stackframe["temp"][:value]
        popStackFrame
        return @head
    end


    def parameterSetup
        paramlen = @head[:constructor][:parameters].length 
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end

        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments but got #{@parameters.length}"
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            
            @@stackframe[@head[:constructor][:parameters][i][:name]] = pm
        end
    end
end