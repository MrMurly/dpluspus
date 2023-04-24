require './ast/Node'

class ReturnNode < Node
    def initialize val
        @val = val
    end

    def evaluate
        @val.evaluate
    end
end