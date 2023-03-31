require './ast/Node'

class BlockNode < Node
  def initialize statement = ""
    @statement = statement
  end

  def evaluate 
    if @statement == ""
      return
    end
    pushStackFrame
    @statement.evaluate 
    popStackFrame
  end
end