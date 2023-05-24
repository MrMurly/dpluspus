require './ast/Node'

##
# A node representing logical expressions.
#
# When evaluated, returns a hash with the value of 
# the operation.

class LogicNode < Node

  ##
  # The operation described by
  # - lhs: the left-hand-side of the operation
  # - rhs: the right-hand-side of the operation
  # - op: Symbol deciding which logical operation 
  #     will occure

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
      if @lhs.evaluate[:type] != @rhs.evaluate[:type]
        raise "Not possible to compare different types!"
      end
      {:value => 
      eval("#{@lhs.evaluate[:value]} #{@op} #{@rhs.evaluate[:value]}"),
      :type => "bool" }
    end
end