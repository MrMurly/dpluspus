require './ast/Node'
require './ast/ReturnNode'

class BlockNode < Node
  def initialize statements = ""
    @statements = statements
  end

  def evaluate 
    pushStackFrame
    if @statements.is_a? Node
      @statements = @statements.evaluate
    end
    popStackFrame
  end
end