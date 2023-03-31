require './ast/Node'

class SymbolNode < Node
    def initialize lhs, symbol, rhs
      @lhs = lhs
      @symbol = symbol 
      @rhs = rhs
    end
  
    def evaluate
      lhs = @lhs.evaluate
      rhs = @rhs.evaluate
      if lhs[:type] != rhs[:type]
        puts "not the same type!"
      end
      {:value => eval("#{lhs[:value]} #{@symbol} #{rhs[:value]}"),
      :type => lhs[:type] }
    end
end