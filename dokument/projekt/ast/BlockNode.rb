require './ast/Node'
require './ast/ReturnNode'

class BlockNode < Node
  def initialize statements = ""
    @statements = statements
  end

  def evaluate 
    pushStackFrame
    if @statements.is_a? Node
      @statements.evaluate
    end
      # @statements.each {|s| s.evaluate}
    popStackFrame
  end
end