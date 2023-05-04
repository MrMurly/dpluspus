require './ast/Node'

##
# A Node representing the initalisation
# of a class. 
# e.g. new Foo();
#
# Once evaluated, returns
# a hash consiting of the newly
# created class instance.

class ClassInitNode < Node
    
    ##
    # Creates a new initalizeNode described by:
    # - classname: name of the class to initalize.
    # - paramaters: a node representing the parameters.

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
        # sets up so anything refering to this.foo, will refer to "this" object 
        # that is being created.
        @@stackframe["this"] = "temp" 
        @@stackframe["temp"] = {:value => @head, :type => @classname }
        if @head[:constructor][:block].is_a? Node
            @head[:constructor][:block].evaluate
        end
        @head = @@stackframe["temp"][:value]
        popStackFrame
        return @head
    end


    ##
    # Sets up the parameters in the stackframe so they
    # have the correct name and values.

    def parameterSetup
        paramlen = @head[:constructor][:parameters].length 
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end

        if paramlen != @parameters.length
            raise "Expected #{paramlen} number of arguments"\
            " but got #{@parameters.length}"
        end

        for i in 0..paramlen-1
            pm = @parameters[i].evaluate
            
            @@stackframe[@head[:constructor][:parameters][i][:name]] = pm
        end
    end
end