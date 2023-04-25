require './ast/Node'
require './ast/ReturnNode'

class BlockNode < Node
  def initialize statements = ""
    @statements = statements
  end
   # @statement => @statemnt => @statement .. => @statement => return;

  def evaluate 
    pushStackFrame
    if @statements.is_a? ReturnNode
      result = @statements.evaluate
      popStackFrame
      return result
    end

    if @statements.is_a? Node
      result = @statements.evaluate
    end
      # @statements.each {|s| s.evaluate}
    popStackFrame
    return result
  end
end