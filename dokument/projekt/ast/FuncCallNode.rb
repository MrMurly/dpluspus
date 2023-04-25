require './ast/Node'
require './Return'



class FuncCallNode < Node

    def initialize(funcname, parameters)
        @funcname = funcname
        @parameters = parameters
    end

    # [{ name=>, val=> }]

    def evaluate
        pushStackFrame
        if @parameters 
            parameterSetup
        end
        begin
            searchStackFrame(@funcname)[:block].evaluate
        rescue Return => e 
            result = e.val
        end
            # @@stackframe[@funcname][:block].evaluate()
        popStackFrame
        return result
    end


    def parameterSetup
        
        func = searchStackFrame(@funcname)
        paramlen = func[:parameters].length

        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end

        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments, but #{@parameters.length} was given."
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            paramtype = func[:parameters][i][:type]
            # if paramtype != @parameters[i][:type]
            #     raise "Expected type #{paramtype} but gor #{@parameters[i][:type]}"
            #     break
            # end
            
            # func[:parameters][i] = @parameters[i]

            @@stackframe[func[:parameters][i][:name]] = pm
        end
    end
end