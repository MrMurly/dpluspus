require './ast/Node'

## 
# An abstract class that is used to 
# represent both 
# ClassBlockFuncNode and ClassBlockVarNode.
# They both use the combine method to 
# turn the definition of variables and 
# methods into a single array

class ClassBlockNode < Node
    def combine(this, identifier, block)
        if block
            block = block.evaluate
            if block.key? identifier
                raise "Duplicate, #{block[identifier]} and #{identifier}"
            end 

            if block.is_a? Node
                return this.merge(block.evaluate)
            end
            return this.merge(block)
        end

        return this
    end
end