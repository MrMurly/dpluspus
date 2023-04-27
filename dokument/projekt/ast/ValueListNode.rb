require './ast/Node'

class ValueListNode < Node
    def initialize value
      @value = value
    end
  
    def evaluate
        @value = @value.evaluate
        @value.map! { |n| n.evaluate}
        return {:value => @value, :type => @value[0][:type]}
    end
end