require './ast/ClassBlockNode'

## 
# A Node representing part of all functions in a
# class. 
#
# When evaluated returns all other functions
# as a list of hashes.

class ClassBlockFuncNode < ClassBlockNode
    
    ##
    # Creates a new ClassFunction described by: 
    # - primitive: a type it must return
    # - identifier: a name for the function
    # - parameters: the paramaters for the function which 
    #       can be a Node that returns a list of hashes.
    # - block: the block of code to be evaluated once the function
    #       is called.
    # - nextfunc: the next function definied by the class.
    
    def initialize(primitive, identifier, parameters=[], block, nextfunc)
        @primitive = primitive
        @identifier = identifier
        @parameters = parameters
        @block = block
        @nextfunc = nextfunc
    end

    def evaluate
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate
        end


        this = {@identifier => {
            :type => "method",
            :return => {:type => @returnType, :val => nil},
            :parameters => @parameters,
            :block => @block
        }}

        return combine(this, @identifier, @nextfunc)
    end
end