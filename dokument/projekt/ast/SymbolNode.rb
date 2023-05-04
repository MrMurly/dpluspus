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
          raise "Not possible to execute with different types!"
        end
        puts "lhs", lhs
        puts "rhs", rhs
        {:value => eval("#{lhs[:value]} #{@symbol} #{rhs[:value]}"),
        :type => lhs[:type] }

    
    end
end