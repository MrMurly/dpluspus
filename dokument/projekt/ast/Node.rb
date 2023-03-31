class Node 
    @@stackframe = {}
  
    def searchStackFrame name
      @@stackframe[name]
    
      currframe = @@stackframe
      while true
        if currframe.key? name
          return currframe[name]
        elsif currframe.key? :prev
          currframe = currframe[:prev]
        else
          puts "no such variable"
          break
        end
      end
    end
    
    def clearStackFrame 
      @@stackframe = {}
    end
  
    def modifyStackFrame name, val
      mStackFrame name, val, @@stackframe
    end
  
    def mStackFrame name, val, frame
      if frame.key? name
        if val[:type] == frame[name][:type]
          frame[name][:value] = val[:value]
          return
        else
          puts "types do not match!"
        end
      elsif frame.key? :prev
        mStackFrame name, val, frame[:prev]
      else
        puts "error bad var"
      end
    end
  
  
    def pushStackFrame
      @@stackframe = {:prev => @@stackframe}
    end
  
    def popStackFrame
      @@stackframe = @@stackframe[:prev]
    end
end