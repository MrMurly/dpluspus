require './ast/Node'

class LogicNode < Node
    def initialize lhs, op, rhs
      @lhs = lhs
      @rhs = rhs
      @op = op
    end
  
    def evaluate
      begin 
        if(@op == "and")
          return {:value => @lhs.evaluate[:value] && @rhs.evaluate[:value],
                  :type => "bool"}
        elsif(@op == "or")
          return {:value => @lhs.evaluate[:value] || @rhs.evaluate[:value],
                  :type => "bool"}
        end
        if @lhs.evaluate[:type] != @rhs.evaluate[:type]
          raise "Not possible to compare different types!"
        end

        {:value => eval("#{@lhs.evaluate[:value]} #{@op} #{@rhs.evaluate[:value]}"),
        :type => "bool" }

      # rescue Exception => e 
      #   puts e.message
        

      end
    end
end