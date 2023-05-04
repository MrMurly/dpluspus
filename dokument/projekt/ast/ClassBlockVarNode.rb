require './ast/ClassBlockNode'

##
# A node representing one of all 
# variables in a class.
#
# When evaluated, returns a list of hashes
# representing all variables.

class ClassBlockVarNode < ClassBlockNode

    ##
    # Creates a new ClassVariable described by:
    # - primitive: a type it must return.
    # - name: the name of the variable
    # - block: next variable block.
    # - isList: if this is a list or not, default false.

    def initialize(primitive, name, block, isList=false)
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