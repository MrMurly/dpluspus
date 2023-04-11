require './ast/Node'

class MainNode < Node 
    def initialize other, nxt
        @other = other
        @nxt = nxt
    end

    def evaluate 
        @other.evaluate
        @nxt.evaluate
    end
end