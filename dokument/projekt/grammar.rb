require './rdparse'
#require './ast/Node'
require './ast/BlockNode'  #Nuvarande lösning, Finns bättre sätt att läsa in filerna.
require './ast/IfElseNode'
require './ast/LogicNode'
require './ast/IfNode'
require './ast/StatementNode'
require './ast/SymbolNode'
require './ast/ValueNode'
require './ast/VariableAssignmentNode'
require './ast/VariableNode'
require './ast/VariableSetNode'
require './ast/DeclareFuncNode'
require './ast/FuncCallNode'
require './ast/ParamNode'
require './ast/LoopNode'
#Dir["/ast/*.rb"].each { |file| require "./#{file}" - 3} #Funkar inte förstår ej varför.
#require './ast'

class Variable
  def initialize name
    @name = name
  end
  def name
    @name
  end
end

class Char
  def initialize value
    @value = value.delete "'"
  end
  def value
    @value
  end
end


class DnD

    def initialize
        Node.new.clearStackFrame
        @dndParser = Parser.new("DnD") do
          # @variables = {}

          token(/\s+/)
          #token(/\d+/) {|m| m.to_i }
          token(/if/) { |m| m}
          token(/else/) { |m| m}
          token(/True/) { |m| m}
          token(/False/) { |m| m}
          token(/for/) { |m| m}
          token(/while/) { |m| m}


          token(/char/) {|m| m}
          token(/int/) {|m| m}
          token(/float/) {|m| m}
          token(/bool/) {|m| m}
          token(/string/) {|m| m}
          token(/void/) {|m| m}
          
          
          token(/\|\|/) {|m| m}
          token(/&&/) {|m| m}
          token(/=/) {|m| m}
          token(/!=/) {|m| m}
          token(/>/) {|m| m}
          token(/</) {|m| m}
          token(/\'.\'/) {|m| Char.new m}
          token(/[a-zA-Z]\w*/) {|m| Variable.new m}
          token(/\d+/) {|m| m.to_i}
          token(/./) {|m| m }

          start :begin do 
            match(:while)
            match(:for)
            match(:function)
            match(:call)
            match(:varset)
            match(:boolean)
            match(:if)
            match(:block)
          end

          #BLOCK
          rule :block do
            match('{', :statements, '}') {|_, a, _| BlockNode.new(a)}
            match('{','}') {|_, _| BlockNode.new }
          end

          rule :statements do
            match(:statement, ';', :statements) {|a, _, b| StatementNode.new(a, b)}
            match(:statement, ';') 
          end

          rule :statement do
            match(:varset)
            match(:if)
            match(:boolean)
            match(:for)
            match(:while)
          end
          #END

          #FUNCTIONS
          rule :function do
            match(:primitive, :identifier, "(", :params, ")", :block) {|a, b, _, c, _, d| DeclareFuncNode.new(a, b, c, d)}
            match(:primitive, :identifier, "(", ")", :block) {|a, b, _, _, d| DeclareFuncNode.new(a, b, nil, d)}
          end

          rule :call do
            match(:identifier, "(", :callparams, ")") { |a, _, b, _| FuncCallNode.new(a, b)}
            match(:identifier, "(", ")") { |a, _, _| FuncCallNode.new(a, nil)}
          end

          rule :params do
            match(:params, ",", :param) {|a, _, b| ParamNode.new(a, b)}
            match(:param) 
          end

          rule :param do
            match(:primitive, :identifier) {|a, b| [{:name => b, :type => a}]}
          end
          
          rule :callparams do 
            match(:callparams, ",", :var) {|a, _, b| ParamNode.new(a, b)}
            match(:var) {|a| [a]}
          end
          #END

          #LOOPS
          rule :while do
            match("while", "(", :boolean, ")", :block) {|_, _, a, _, b| LoopNode.new(nil, nil, a, b)}
          end
          
          rule :for do
            match("for", "(", :varset, ";",  :varset, ";", :boolean,")", :block) {|_,_, a, _, b, _, c, _, d| LoopNode.new(a, b, c, d)}
          end
          #END

          #IF-STATEMENTS
          rule :if do 
            match('if', '(', :boolean, ')', :block, :else) {|_,_, a, _, b, c| IfElseNode.new(a, b, c)}
            match('if', '(', :boolean, ')', :block) {|_,_, a, _, b| IfNode.new(a, b)}
          end

          rule :else do
            match('else', 'if', '(', :boolean, ')', :block, :else) {|_, _, _, a, _, b, c| IfElseNode.new(a, b, c)}
            match('else', 'if', '(', :boolean, ')', :block) {|_, _, _, a, _, b| IfNode.new(a, b)}
            match('else', :block) {|_, a| a}
          end
          #END

          #LOGIC/ARITEMIK
          rule :boolean do
              match(:boolean, "||", :and) {|a, _, b| LogicNode.new a, "or", b}
              match(:and)
          end
          
          rule :and do
            match(:and, "&&", :relation) {|a, _, b| LogicNode.new a, "and", b}
            match(:relation)
          end
          
          rule :relation do
            match(:relation, "!=", :addition) { |a, _, b| LogicNode.new a, :!=, b} 
            match(:relation, "=", "=", :addition) { |a, _, _, b| LogicNode.new a, :==, b} 
            match(:relation, "<", "=", :addition) { |a, _, _, b| LogicNode.new a, :<=, b} 
            match(:relation, ">", "=", :addition) { |a, _, _, b| LogicNode.new a, :>=, b} 
            match(:relation, "<", :addition) { |a, _, b| LogicNode.new a, :<, b}  
            match(:relation, ">", :addition) { |a,  _, b| LogicNode.new a, :>, b} 
            match(:addition)
          end
          
          rule :addition do
            match(:addition, '+', :multi) {|a, _, b| SymbolNode.new a, :+, b}
            match(:addition, '-', :multi) {|a, _, b| SymbolNode.new a, :-, b}
            match(:multi)
          end

          rule :multi do
            match(:term, '^', :multi) { |a, _, b| SymbolNode.new a, :**, b } 
            match(:multi, '/', :term) { |a, _, b| SymbolNode.new a, :/, b }
            match(:multi, '*', :term) { |a, _, b| SymbolNode.new a, :*, b } 
            match(:multi, '%', :term) { |a, _, b| SymbolNode.new a, :%, b }
            match(:term)
          end

          rule :term do
            match("(", :boolean, ")") 
            match('True') { |a| ValueNode.new true, "bool"}
            match('False') {|a| ValueNode.new false, "bool"}
            match(:var)
          end
          
          rule :var do
            match(:float)
            match(:int)
            match(:char)
            match(:varget)
            #match(:list)
          end

          rule :float do
            match(Integer, ".", Integer)  { |a, _, b| ValueNode.new((a.to_s + "." + b.to_s).to_f, "float") }
          end

          rule :int do
            match(Integer) { |a| ValueNode.new a, "int"}
          end

          rule :char do
            match(Char) {|a| ValueNode.new a.value, "char"} 
          end

          rule :identifier do
            match(Variable) {|a| a.name }
          end

          rule :varget do 
            match(:identifier) {|a| VariableNode.new a}
          end

          rule :varset do
            match(:identifier, '=', :boolean) {|a, _, b| VariableAssignmentNode.new a, b}
            match(:primitive, :identifier, '=', :boolean) {|a, b, _, c| VariableSetNode.new b, a, c} 
          end

          rule :primitive do
            match('char')
            match('int')
            match('float')
            match('bool')
            match('string')
            match('void')
          end
          
          rule :name do
            match(/[a-zA-Z]\w*/)
          end
          #END

        end
      end
      
    def done(str)
        ["quit","exit","bye","done",""].include?(str.chomp)
    end
    
    def parse
      print "[DnD] "
      str = gets
      if done(str) then
        puts "Bye."
      else
        puts "=> #{@dndParser.parse(str).evaluate}"
        parse
      end
    end

    def testParse str
      @dndParser.parse(str).evaluate
    end

    def log(state = true)
        if state
            @dndParser.logger.level = Logger::DEBUG
        else
            @dndParser.logger.level = Logger::WARN
        end
    end
end

DnD.new.parse