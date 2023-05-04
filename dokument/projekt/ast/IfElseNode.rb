require './ast/Node'

##
# A Node representing a if- else statement.
#
# When evaluate, runs either the corresponding 
# block if the boolean is true, or goes to the 
# else node.

class IfElseNode < Node
  
  ##
  # Creates a If Else Node described by:
  # - boolean: the boolean expression to be evaluated
  # - block: the block of code to run if the expression
  #     is true.
  # - elseNode: A node to evaluate if the boolean is false. 
  
  def initialize(boolean, block, elseNode)
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