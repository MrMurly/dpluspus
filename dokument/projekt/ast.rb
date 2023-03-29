class Node 
  @@stackframe = {}

  def searchStackFrame name
    @@stackframe[name]
  end

  # arr = []

  # arr.map!(:& to_i)

  # new_arr = arr.map(:& to_i)

  def modifyStackFrame name, val
    
    stackframe = @@stackframe
    while true
      if stackframe.key? name 
        stackframe[name][:value] = val
        break
      elsif stackframe.key? :prev 
        stackframe = stackframe[:prev]
      end  
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
  def initialize statement=""
    @statement = statement
  end

  def evaluate 
    if (@statement == "")
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
    @nextStatement.evaluate
  end
end

class IfElseNode < Node
  def initialize boolean, block, elseNode
    @boolean = boolean
    @block = block
    @else = elseNode
  end

  def evaluate 
    if @boolean.evaluate
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
    if @boolean
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
    eval("#{@lhs.evaluate} #{@symbol} #{@rhs.evaluate}")
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
      return @lhs.evaluate && @rhs.evaluate
    end
    if(@op == "or")
      return @lhs.evaluate || @rhs.evaluate
    end
  end
end

class ValueNode < Node
  def initialize value
    @value = value
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
    # TODO: om inte finns i närmaste stackframe, gå vidare till nästa, tills du kommer till den
    # globala och därmed "sista" framen.
    @@stackframe[@name][:value]
  end
end

class VariableSetNode < Node
  def initialize name, type, expression
    @name = name
    @expression = expression
    @type = type
  end

  def evaluate
    @@stackframe[@name] = {:value => @expression.evaluate, :type => @type}
  end
end

class VariableAssignmentNode < Node
  def initialize name, expression
    @name = name
    @expression = expression
  end

  def evaluate
    # @@stackframe[@name][:value] = @expression.evaluate 
    modifyStackFrame @name, @expression.evaluate
    #puts @@stackframe
  end

end