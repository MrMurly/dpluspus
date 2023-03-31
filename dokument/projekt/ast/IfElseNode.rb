require './ast/Node'

class IfElseNode < Node
    def initialize boolean, block, elseNode
      @boolean = boolean
      @block = block
      @else = elseNode
    end
  
    def evaluate 
      if @boolean.evaluate[:value]
        @block.evaluate
      else 
        @else.evaluate
      end
    end
end