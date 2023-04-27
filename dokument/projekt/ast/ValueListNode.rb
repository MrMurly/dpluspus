require './ast/Node'

class ValueListNode < Node
    def initialize value
      @value = value
    end
  
    def evaluate
      puts "vallist #{@value}"
      puts @value.is_a? Node
      if @value.is_a? Node
        @value = @value.evaluate
        @value.map! { |n| n.evaluate}
      end
      return {:value => @value, :type => @value[0][:type]}
    end
end