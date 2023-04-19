require './ast/Node'

class ReturnNode 
    def initialize val
        @val = val
    end

    def evaluate
        @val.evaluate
    end
end