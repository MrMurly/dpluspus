require './ast/Node'

class ClassElemNode < Node
    def initialize classname, varname, pos
      @classname = classname
      @varname = varname
      @pos = pos
    end
  
    def evaluate
        if @pos.is_a? Node
            @pos = @pos.evaluate
        end
      puts "hej", searchStackFrame(@classname)[:value][:members][@varname]
      searchStackFrame(@classname)[:value][:members][@varname][:value][@pos[:value]]
    end
end