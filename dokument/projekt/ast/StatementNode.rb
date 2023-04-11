require './ast/Node'

class StatementNode < Node
    def initialize statement, nextStatement
      @statement = statement
      @next = nextStatement
    end
  
    def evaluate 
      if @next.is_a? StatementNode 
        @statement = @next.evaluate.concat(@statement)
    end
    @statement
    end
end