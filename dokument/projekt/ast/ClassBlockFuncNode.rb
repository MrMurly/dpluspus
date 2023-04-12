require './ast/ClassBlockNode'

class ClassBlockFuncNode < ClassBlockNode
    def initialize primitive, identifier, parameters, block, nextfunc
        @primitive = primitive
        @identifier = identifier
        @parameters = parameters
        @block = block
        @nextfunc = nextfunc
    end

    def evaluate
        if @parameters.is_a? Node
            @parameters = @parameters.evaluate

        this = {@identifier => {
            :type => "method",
            :return => {:type => @returnType, :val => nil},
            :parameters => @parameters,
            :block => @block
        }}

        return combine(this, @identifier, @nextfunc)
    end
end