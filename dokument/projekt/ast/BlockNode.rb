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

    @statements.each { |statement|
      statement.evaluate
    }
    
    popStackFrame
  end
end