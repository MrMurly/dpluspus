require './ast/Node'


##
# A node representing the top most definition of a class.
#
# When evaluated adds its defintion to the stackframe in the 
# format: 
# {
#   :constructor => ...,
#   :methods => [...],
#   :members => [...],
#   :type => ""    
# }

class ClassNode < Node

    ##
    # creates a new Class described by:
    # - name: the class' name.
    # - variables: a node representing the class' variables.
    # - constructor: a node representing the class' constructor.
    # - methods: a node representing the class' methods.
    
    def initialize(name, variables, constructor, methods)
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