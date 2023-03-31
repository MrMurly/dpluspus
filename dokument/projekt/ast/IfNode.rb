require './ast/Node'

class IfNode < Node
    def initialize boolean, block
      @boolean = boolean
      @block = block
    end
  
    def evaluate
      if @boolean.evaluate[:value]
        @block.evaluate
      end
    end
end