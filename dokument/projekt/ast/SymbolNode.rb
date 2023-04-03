require './ast/Node'

class SymbolNode < Node
    def initialize lhs, symbol, rhs
      @lhs = lhs
      @symbol = symbol 
      @rhs = rhs
    end
  
    def evaluate
      begin
        lhs = @lhs.evaluate
        rhs = @rhs.evaluate
        if lhs[:type] != rhs[:type]
          raise "Not possible to execute with different types!"
        end
        {:value => eval("#{lhs[:value]} #{@symbol} #{rhs[:value]}"),
        :type => lhs[:type] }

      rescue Exception => e #user defined exception
        puts e.message

      end
    end
end