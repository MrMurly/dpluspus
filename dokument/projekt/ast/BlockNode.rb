require './ast/Node'
require './ast/ReturnNode'

class BlockNode < Node
  def initialize statements = ""
    @statements = statements
  end
   # @statement => @statemnt => @statement .. => @statement => return;

  def evaluate 
    pushStackFrame
    #puts @statements.is_a? ReturnNode
    if @statements.is_a? ReturnNode
      #puts "return statement"
      result = @statements.evaluate
      popStackFrame
      return result
    end

    if @statements.is_a? Node
      puts "vanligt statement"
      result = @statements.evaluate
    end
    popStackFrame
    return result
  end
end