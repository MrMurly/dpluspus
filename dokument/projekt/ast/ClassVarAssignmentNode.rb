require './ast/Node'

class ClassVarAssignmentNode < Node
    def initialize classname, varname, expression
        @classname = classname
        @varname = varname
        @expression = expression
    end

    def evaluate
        modifyStackFrame @classname, @varname, @expression.evaluate
    end


    def modifyStackFrame cname, vname, val
        mStackFrame cname, vname, val, @@stackframe
      end
    
      def mStackFrame cname, vname, val, frame
        if frame.key? cname
          #TODO: error handling   
          if (cname == "this")
            return mStackFrame frame[cname], vname, val, frame
          end
          frame[cname][:value][:members][vname][:value] = val[:value]
            
        elsif frame.key? :prev
          mStackFrame cname, vname, val, frame[:prev]
        else
          puts @@stackframe
          raise "error; #{cname} doesn't exist!"
        end
        
      end
end