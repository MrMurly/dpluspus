require './ast/Node'
require './ast/ReturnNode'

##
# Node representing anything between {...}
# constists of a StatementNode which
# points to the next statement etc.
#
# Once evaluated, pushes a new frame
# unto the stackframe and before it is
# done, pops it.

class BlockNode < Node

  ##
  # Creates a new blocknode
  # with a ref to the first
  # statement in the block.

  def initialize(statements = "")
    @statements = statements
  end

  def evaluate 
    pushStackFrame
    if @statements != ""
      @statements.evaluate
    end
    popStackFrame
  end
end