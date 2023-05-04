require './ast/Node'

##
# A node representing the declaration of a function.
#
# when evaluated, modifies the current stackframe
# with the definition of the function.

class DeclareFuncNode < Node

    ##
    # Creates a new FunctionDeclartion described by:
    # - returnType: the type which the function must return.
    # - name: the name of function.
    # - paramaters: the parameters for the function which 
    #       can be a Node that returns a list of hashes.
    # - block: the block of code to be evaluated once the function
    #       is called.

    def initialize(returnType, name, parameters, block)
        @returnType = returnType
        @name = name
        @parameters = parameters
        @block = block
    end

    def evaluate
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end
        @@stackframe[@name] = {
            :return => {:type => @returnType, :val => nil},
            :parameters => @parameters,
            :block => @block
        }
    end

end