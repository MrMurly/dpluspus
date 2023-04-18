require './ast/Node'

class ClassVarNode < Node
    def initialize classname, varname
      @classname = classname
      @varname = varname
    end
  
    def evaluate
      searchStackFrame(@classname)[:value][:members][@varname]
    end
end