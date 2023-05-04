
##
# Abstract class representing any Node in the AST.
#
# Stackframe is a "static" member variable, which keeps
# the entire stackframe and is accessible by all child
# nodes.

class Node 

    # The stackframe, represented by a hash.
    @@stackframe = {}
    
    ##
    # Iterates through the stackframe for a key, name, and returns the result.
    # has a special case for when the name is "this", then it instead searches
    # for the value stored in "this". If the value stored in "this" is "this",
    # which can happen when recursive calls are made inside a method call, it
    # still searches for "this", but in the previous frame.
    def searchStackFrame(name) 
      currframe = @@stackframe
      while true
        if currframe.key? name
          if name == "this"
            if currframe[name] == "this" 
              currframe = currframe[:prev]
            else
              return searchStackFrame(currframe[name])
            end
          else
            return currframe[name]
          end
        elsif currframe.key? :prev
          currframe = currframe[:prev]
        else
          raise "Undefined variable #{name}"
          break
        end
      end
    end
    
    ##
    # empties the stackframe, and resets it to a empty hash.
    def clearStackFrame 
      @@stackframe = {}
    end
  
    ##
    # Helper function, that modifies the stackframe by searching
    # it recursivly.  
    def modifyStackFrame(name, val)
      mStackFrame name, val, @@stackframe
    end
  
    ##
    # Worker function, see modifyStackFrame for explanation.
    #
    def mStackFrame(name, val, frame)
      if frame.key? name
        if val[:type] == frame[name][:type]
          frame[name][:value] = val[:value]
          return
        else
          raise "types of #{name} with type #{frame[name][:type]} and #{val[:type]}"
        end
      elsif frame.key? :prev
        mStackFrame name, val, frame[:prev]
      else
        raise "error; #{name} doesn't exist!"
      end
      
    end
  
    ##
    # Creates a new stackframe and adds the previous stackframe under the key
    # :prev. Therby "pushing" a new frame unto the stack.
    def pushStackFrame
      @@stackframe = {:prev => @@stackframe}
    end
    
    ##
    # Removes the previous stackframe, now the current stackframe is whatever
    # was under the :prev key. 
    def popStackFrame
      @@stackframe = @@stackframe[:prev]
    end
end