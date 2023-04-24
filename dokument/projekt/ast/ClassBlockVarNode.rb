require './ast/ClassBlockNode'

class ClassBlockVarNode < ClassBlockNode
    def initialize primitive, name, block
        @primitive = primitive
        @name = name
        @block = block
    end

    def evaluate
        
       this = {@name => {
        :type => @primitive,
        :value => nil
       } }


       return combine(this, @name, @block)
    end
end