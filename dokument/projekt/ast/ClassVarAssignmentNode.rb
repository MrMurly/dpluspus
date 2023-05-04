require './ast/Node'

##
# A node representing the assignement 
# of a member variable. e.g. foo.bar = 0; 
#
# overwrites the modifiy stackframe method from
# node.
#
# When evaluated, modifies the stackframe were
# the class instance exists.

class ClassVarAssignmentNode < Node

    ##
    # Creates a new ClassVariableAssignment described by:
    # - classname: name of the class instance.
    # - varname: name of the member variable.
    # - expression: a node representing a value.

    def initialize(classname, varname, expression)
        @classname = classname
        @varname = varname
        @expression = expression
    end

    def evaluate
        modifyStackFrame @classname, @varname, @expression.evaluate
    end


    def modifyStackFrame(cname, vname, val)
      mStackFrame cname, vname, val, @@stackframe
    end
    
    ##
    # Searches the stackframe recursivly for the class name
    # if it finds it in the current frame, and its name is "this"
    # recusivly finds the "actual" variable which was stored in the "this" 
    # hash.
    
    def mStackFrame(cname, vname, val, frame)
      if frame.key? cname
        if (cname == "this")
          return mStackFrame frame[cname], vname, val, frame
        end
        frame[cname][:value][:members][vname][:value] = val[:value]
          
      elsif frame.key? :prev
        mStackFrame cname, vname, val, frame[:prev]
      else
        raise "error; #{cname} doesn't exist!"
      end
      
    end
end