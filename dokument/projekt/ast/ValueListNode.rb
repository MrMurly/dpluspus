require './ast/Node'

##
# A node that creates a hash containing
# the list and the what type of list 
# it is so that it follows structure of 
# the stackframe


class ValueListNode < Node

  ##
  # Creats the hash by taking
  # - value: the list containing all of the elements

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