require './ast/Node'

##
# A node representing a single if statement.
#
# when evaluated, runs the block if the boolean
# is true.

class IfNode < Node

  ##
  # Creates a new IfNode described by:
  # - boolean: a boolean expression to be evaluated.
  # - block: a block of code to run if the expression is true.

  def initialize(boolean, block)
      @boolean = boolean
      @block = block
    end
  
    def evaluate
      if @boolean.evaluate[:value]
        @block.evaluate
      end
    end
end