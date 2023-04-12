require './ast/Node'

class ClassBlockNode < Node
    def initialize name, block
        @name = name
        @block = block
    end

    def evaluate
        @@stackframe[@name] = {:block => @block, :type => @class}
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