
class Node 
    @@stackframe = {}
  
    def searchStackFrame name 
      begin
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
      # rescue Exception => e 
      #   puts e.message
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
          raise "types of #{name} with type #{frame[name][:type]} and #{val[:type]}"
        end
      elsif frame.key? :prev
        mStackFrame name, val, frame[:prev]
      else
        puts @@stackframe
        raise "error; #{name} doesn't exist!"
      end
      
    end
  
  
    def pushStackFrame
      @@stackframe = {:prev => @@stackframe}
    end
  
    def popStackFrame
      @@stackframe = @@stackframe[:prev]
    end
end