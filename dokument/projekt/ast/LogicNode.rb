require './ast/Node'

class LogicNode < Node
    def initialize lhs, op, rhs
      @lhs = lhs
      @rhs = rhs
      @op = op
    end
  
    def evaluate
      if(@op == "and")
        return {:value => @lhs.evaluate[:value] && @rhs.evaluate[:value],
                :type => "bool"}
      elsif(@op == "or")
        return {:value => @lhs.evaluate[:value] || @rhs.evaluate[:value],
                :type => "bool"}
      end
      {:value => eval("#{@lhs.evaluate[:value]} #{@op} #{@rhs.evaluate[:value]}"),
      :type => "bool" }
    end
end