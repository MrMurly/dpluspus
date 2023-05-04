require './ast/Node'

##
# A node representing a single statement
#
# when evaluated, evaluates the current statement
# and if there is a nextStatement, evaluates that as well.

class StatementNode < Node
  
    ##
    # Creates a new StatementNode described by:
    # - statement: the current statement this should evaluate.
    # - nextStatement: the next statement to be evaluated, can be
    #     another statement node or another type of Node.

    def initialize(statement, nextStatement)
      @statement = statement
      @nextStatement = nextStatement
    end
  
    def evaluate 
      @statement.evaluate
      if @nextStatement
        @nextStatement.evaluate
      end
    end
end