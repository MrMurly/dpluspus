require './ast/Node'

class PrintNode < Node
    def initialize obj
        @obj = obj
    end

    def evaluate
        puts @obj.evaluate
    end
end