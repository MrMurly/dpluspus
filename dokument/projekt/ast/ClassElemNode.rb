require './ast/Node'

class ClassElemNode < Node
    def initialize classname, varname, pos
      @classname = classname
      @varname = varname
      @pos = pos
    end
  
    def evaluate
        @pos = @pos.evaluate
      searchStackFrame(@classname)[:value][:members][@varname][:value][@pos]
    end
end