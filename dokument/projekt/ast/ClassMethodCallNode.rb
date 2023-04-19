require './ast/Node'

class ClassMethodCallNode < Node 
    def initialize varname, methodname, parameters=""
        @varname = varname
        @methodname = methodname
        @parameters = parameters
    end

    def evaluate
        puts searchStackFrame(@varname)[:value][@methodname]
    end
end