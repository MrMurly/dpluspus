require './ast/Node'
require './ast/ReturnNode'

class BlockNode < Node
  def initialize statements = ""
    @statements = statements
  end

  def evaluate 
    pushStackFrame
    @statements.evaluate
    # @statements.each {|s| s.evaluate}
    popStackFrame
  end
end