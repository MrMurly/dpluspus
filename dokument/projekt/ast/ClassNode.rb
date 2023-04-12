require './ast/Node'

class ClassNode < Node
    def initialize name, variables, methods
        @name = name
        @variables = variables
        @methods = methods
    end

    def evaluate
        if @methods
            @methods = @methods.evaluate
        else
            @methods = {}
        end

        if @variables
            @variables = @variables.evaluate
        else 
            @variables = {}
        end

        @@stackframe[@name] = {:methods => @methods, :members => @variables, :type => "class"}
    end
end