require './ast/Node'

##
# A node representing getting the value from a member variable.
# e.g. foo.bar
#
# When evaluated, returns the value of the member variable.

class ClassVarNode < Node

  ##
  # Creates a new ClassVariable described by:
  # - classname: the instance classname 
  # - varname: the member variable name.
  
  def initialize(classname, varname)
    @classname = classname
    @varname = varname
  end
  
  def evaluate
    searchStackFrame(@classname)[:value][:members][@varname]
  end
end