require './ast/Node'

class StatementNode < Node
    def initialize statement, nextStatement
      @statement = statement
      @next = nextStatement
    end
  
    def evaluate 
      @statement.evaluate
      @next.evaluate
    end
end