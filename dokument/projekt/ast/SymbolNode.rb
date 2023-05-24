require './ast/Node'

##
# A node representing arithmetic expression
#
# When evaluated returns a hash with the value of 
# the expression.


class SymbolNode < Node

  ##
  # The expression described by
  # - lhs: the left-hand-side of the operation
  # - symbol: Symbol deciding which arithmetic operation 
  #     will occure
  # - rhs: the right-hand-side of the operation

    def initialize lhs, symbol, rhs
      @lhs = lhs
      @symbol = symbol 
      @rhs = rhs
    end
  
    def evaluate
        lhs = @lhs.evaluate
        rhs = @rhs.evaluate
        if lhs[:type] != rhs[:type]
          raise "Not possible to execute with different types!"
        end

        {:value => eval("#{lhs[:value]} #{@symbol} #{rhs[:value]}"),
        :type => lhs[:type] }

    
    end
end