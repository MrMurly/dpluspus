require './ast/Node'

class StatementNode < Node
    def initialize statement, nextStatement
      @statement = [statement]
      @next = nextStatement
    end
  
    def evaluate 
      if @next.is_a? StatementNode 
        @statement = @next.evaluate.concat(@statement)
      end
      # if @next.is_a? Array
      #   #puts "#{@next} AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      #   @statement = @next.concat(@statement)
      # end
    @statement
    end
end