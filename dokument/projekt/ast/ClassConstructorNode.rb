require './ast/ClassBlockNode'


##
# A node presenting the constructor for a class.
# 
# When evaluated, returns a single hash
# describing the constructor.

class ClassConstructorNode < ClassBlockNode

    ##
    # Creates a new ConstructorNode described by:
    # - classname: name of the class that the constructor
    #       is for.
    # - parameters: the parameters that the constructor has.
    # - block: a block of code to be executed when the 
    #       constructor is called.

    def initialize(classname, parameters=[], block)
        @classname = classname
        @parameters = parameters
        @block = block
    end

    def evaluate
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end
        return {
            :type => "constructor",
            :parameters => @parameters,
            :block => @block
        }
    end
end