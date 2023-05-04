require './ast/Node'

##
# A node representing the value of primitives.
#
# When evaluated, returns a hash with the value and
# type of the primitive.


class ValueNode < Node
    def initialize value, type
      @value = {:value => value, :type => type}
    end
  
    def evaluate
      @value
    end
end