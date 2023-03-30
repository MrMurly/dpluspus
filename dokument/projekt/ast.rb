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

class BlockNode < Node
  def initialize statement = ""
    @statement = statement
  end

  def evaluate 
    if @statement == ""
      return
    end
    pushStackFrame
    @statement.evaluate 
    popStackFrame
  end
end

class StatementNode < Node
  def initialize statement, nextStatement
    @statement = statement
    @next = nextStatement
  end

  def evaluate 
    @statement.evaluate
    @next.evaluate
  end
end

class IfElseNode < Node
  def initialize boolean, block, elseNode
    @boolean = boolean
    @block = block
    @else = elseNode
  end

  def evaluate 
    if @boolean.evaluate[:value]
      @block.evaluate
    else 
      @else.evaluate
    end
  end
end

class IfNode < Node
  def initialize boolean, block
    @boolean = boolean
    @block = block
  end

  def evaluate
    if @boolean.evaluate[:value]
      @block.evaluate
    end
  end
end

class SymbolNode < Node
  def initialize lhs, symbol, rhs
    @lhs = lhs
    @symbol = symbol 
    @rhs = rhs
  end

  def evaluate
    lhs = @lhs.evaluate
    rhs = @rhs.evaluate
    if lhs[:type] != rhs[:type]
      puts "not the same type!"
    end
    {:value => eval("#{lhs[:value]} #{@symbol} #{rhs[:value]}"),
    :type => lhs[:type] }
  end
end

class LogicNode < Node
  def initialize lhs, op, rhs
    @lhs = lhs
    @rhs = rhs
    @op = op
  end

  def evaluate
    if(@op == "and")
      return {:value => @lhs.evaluate[:value] && @rhs.evaluate[:value],
              :type => "bool"}
    elsif(@op == "or")
      return {:value => @lhs.evaluate[:value] || @rhs.evaluate[:value],
              :type => "bool"}
    end
    {:value => eval("#{@lhs.evaluate[:value]} #{@op} #{@rhs.evaluate[:value]}"),
    :type => "bool" }
  end
end

class ValueNode < Node
  def initialize value, type
    @value = {:value => value, :type => type}
  end

  def evaluate
    @value
  end
end

class VariableNode < Node
  def initialize name
    @name = name
  end

  def evaluate
    searchStackFrame @name
  end
end

class VariableSetNode < Node
  def initialize name, type, expression
    @name = name
    @expression = expression
    @type = type
  end

  def evaluate
    expression = @expression.evaluate
    if @type != expression[:type]
      puts "types don't match!"
      return
    end

    @@stackframe[@name] = {:value => expression[:value], :type => @type}
  end
end

class VariableAssignmentNode < Node
  def initialize name, expression
    @name = name
    @expression = expression
  end

  def evaluate
    modifyStackFrame @name, @expression.evaluate
  end

end