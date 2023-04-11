require './ast/Node'

class ClassBlockNode < Node
    def initialize name, block
        @name = name
        @block = block
    end

    def evaluate
        @@stackframe[@name] = {:block => @block, :type => @class}
    end
end