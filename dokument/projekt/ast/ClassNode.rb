require './ast/Node'

class ClassNode < Node
    def initialize name, variables, constructor, methods
        @name = name
        @constructor = constructor
        @variables = variables
        @methods = methods
    end

    def evaluate
        if @methods
            @methods = @methods.evaluate
        else
            @methods = {}
        end

        if @constructor
            @constructor = @constructor.evaluate
        else
            @constructor = {}
        end

        if @variables
            @variables = @variables.evaluate
        else 
            @variables = {}
        end

        @@stackframe[@name] = {
            :constructor => @constructor,
            :methods => @methods, 
            :members => @variables, 
            :type =>  @name
        }
    end
end