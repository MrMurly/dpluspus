require './ast/Node'

class ValueNode < Node
    def initialize value, type
      @value = {:value => value, :type => type}
    end
  
    def evaluate
      @value
    end
end