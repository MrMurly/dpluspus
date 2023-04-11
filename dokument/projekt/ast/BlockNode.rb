require './ast/Node'
require './ast/ReturnNode'

class BlockNode < Node
  def initialize statements = ""
    @statements = statements
  end

  def evaluate 
    if @statements.is_a? Node
      @statements = @statements.evaluate
    end
    pushStackFrame
    
    for i in 0..@statements.length-1
      curr = @statements[i]
      if curr.is_a? ReturnNode
        curr.evaluate
      end
      curr.evaluate
    end
 
    popStackFrame
  end
end