require './ast/Node'

class ClassBlockNode < Node
    def combine this, identifier, block
        if block
            block = block.evaluate
            if block.key? identifier
                raise "Duplicate, #{block[identifier]} and #{identifier}"
            end 
            return this.merge(block.evaluate)
        end

        return this
    end

    def combine this, identifier, block
        if block
            block = block.evaluate
            if block.key? identifier
                raise "Duplicate, #{block[identifier]} and #{identifier}"
            end 
            return this.merge(block.evaluate)
        end

        return this
    end
end