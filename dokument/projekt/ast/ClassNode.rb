require './ast/Node'

class ClassNode < Node
    def initialize name, block
        @name = name
        @block = block
    end

    def evaluate
        @@stackframe[@name] = {:block => @block, :type => "class"}
    end
end