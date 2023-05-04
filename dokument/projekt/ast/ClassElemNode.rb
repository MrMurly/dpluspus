require './ast/Node'

##
# a node representing
# getting a value from a 
# member array.
# e.g. foo.bar[0];
#
# When evaluted returns the 
# value and type for the specific
# value.

class ClassElemNode < Node

    ##
    # Creates a new ElementNode described by:
    # - classname: name of the class instance.
    # - varname: name of member list.
    # - pos: the position of the element to get.

    def initialize(classname, varname, pos)
      @classname = classname
      @varname = varname
      @pos = pos
    end
  
    def evaluate
        if @pos.is_a? Node
            @pos = @pos.evaluate
        end
      searchStackFrame(@classname)[:value][:members][@varname][:value][@pos[:value]]
    end
end