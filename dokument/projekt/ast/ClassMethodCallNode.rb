require './ast/FuncCallNode'
require './Return'

##
# A node representing a the call for a class method.
# e.g. foo.bar();
#
# When evaluated returns the result from the method
# call. It also pushes the stackframe as well as 
# adds a "this" with the value of varname. So
# when this.foo is called inside the method, it can 
# look up which instance of the object to find.

class ClassMethodCallNode < Node 

    ##
    # Creates a new MethodCall described by:
    # - varname: the instance of the class
    # - methodname: name fo the method being called.
    # - parameters: a node or empty list consting of all
    #       the parameters being called.
    
    def initialize(varname, methodname, parameters=[])
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

    ##
    # Sets up the parameters in the stackframe so they
    # have the correct name and values.

    def parameterSetup
        paramlen = @head[:parameters].length        
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end

        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments but"\
            " got #{@parameters.length}"
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            paramtype = @head[:parameters][i][:type]
            @@stackframe[@head[:parameters][i][:name]] = pm
        end
    end
end