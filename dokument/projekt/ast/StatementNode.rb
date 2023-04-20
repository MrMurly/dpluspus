require './ast/Node'

class StatementNode < Node
    def initialize statement, nextStatement
      @statement = statement
      @nextStatement = nextStatement
    end
  
    def evaluate 
      @statement.evaluate
      #puts "AAAAAAAAAAAAAAAA#{@nextStatement}"
      #puts "AAAAAAAAAAAAAAAAAAAAA#{@nextStatement.evaluate}"
      if @nextStatement
        return @nextStatement.evaluate
      end
    end
end