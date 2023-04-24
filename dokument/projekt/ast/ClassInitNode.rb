require './ast/Node'

class ClassInitNode < Node

    def initialize(classname, parameters)
        @classname = classname
        @parameters = parameters
    end

    def evaluate
        searchStackFrame(@classname)
    end


    def parameterSetup
        
        func = searchStackFrame(@classname)
        paramlen = func[:parameters].length
        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments, but #{@parameters.length} was given."
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            paramtype = func[:parameters][i][:type]

            @@stackframe[func[:parameters][i][:name]] = pm
        end
    end
end