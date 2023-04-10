require './ast/Node'

class ClassInitNode < Node

    def initialize(classname, parameters)
        @classname = classname
        @parameters = parameters
    end

    # [{ name=>, val=> }]

    def evaluate
        pushStackFrame
        if @parameters 
            parameterSetup
        end 

        searchStackFrame(@funcname)[:block].evaluate
        # @@stackframe[@funcname][:block].evaluate()
        popStackFrame
    end


    def parameterSetup
        
        func = searchStackFrame(@funcname)
        paramlen = func[:parameters].length
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