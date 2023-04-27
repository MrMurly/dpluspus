require './ast/ClassBlockNode'

class ClassBlockVarNode < ClassBlockNode
    def initialize primitive, name, block, isList=false
        @primitive = primitive
        @name = name
        @block = block
        @isList = isList
    end

    def evaluate
        this = {}
        if @isList
           this = {
            @name => {
                :type => @primitive,
                :value => []
            }} 
        else 
            this = {@name => {
            :type => @primitive,
            :value => nil
            }}
        end

       return combine(this, @name, @block)
    end
end