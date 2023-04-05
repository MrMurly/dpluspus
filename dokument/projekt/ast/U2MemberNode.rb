require './ast/Node'

class Element
    
    attr_accessor :value, :next

    def initialize(value)
        @value = value
        @next = nil
    end

end

class MemberNodeU2 < Node

    def initialize(firstElement, nextElement)
        
    end

    def evaluate

    end
end