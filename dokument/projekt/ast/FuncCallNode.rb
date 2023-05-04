require './ast/Node'
require './Return'

##
# A Node representing the call of a function. 
# e.g. foo();
#
# When evaluated returns the result of the function
# call, if any.

class FuncCallNode < Node

    ##
    # Creates a new Function Call described by:
    # - funcname: the name of the function being called.
    # - parameters: the parameters for the function which
    #       can be a Node that returns  a list of hashes.

    def initialize(funcname, parameters)
        @funcname = funcname
        @parameters = parameters
    end

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
        popStackFrame
        return result
    end

    ##
    # Sets up the parameters in the stackframe so they
    # have the correct name and values.

    def parameterSetup
        
        func = searchStackFrame(@funcname)
        paramlen = func[:parameters].length

        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end

        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments,"\
            " but #{@parameters.length} was given."
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            paramtype = func[:parameters][i][:type]

            @@stackframe[func[:parameters][i][:name]] = pm
        end
    end
end