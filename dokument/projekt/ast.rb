class Node 
end


class SymbolNode < Node
  def initialize lhs, symbol, rhs
    @lhs = lhs
    @symbol = symbol 
    @rhs = rhs
  end

  def evaluate
    if(@lhs.is_a? Node)
      @lhs = @lhs.evaluate
    end
    if(@rhs.is_a? Node)
      @rhs = @rhs.evaluate
    end
    eval("#{@lhs} #{@symbol} #{@rhs}")
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
  def initialize name, variables
    @name = name
    @variables = variables
  end

  def evaluate
    @variables[@name][:value]
  end
end

class VariableSetNode < Node
  def initialize name, type,  expression, variables
    @name = name
    @expression = expression
    @variables = variables
    @type = type
  end

  def evaluate
    @variables[@name] = {:value => @expression.evaluate, :type => @type}
  end
end