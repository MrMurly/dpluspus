require './ast/Node'
require './Return'

class ReturnNode 
    def initialize val
        @val = val
    end

    def evaluate
        raise Return.new @val.evaluate
    end
end