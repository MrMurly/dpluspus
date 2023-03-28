require './rdparse'
require './ast'

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

"variables = {
  x = {
    value: 1,
    type: int
  }
  prev = {
    y = {
      value: true,
      type: bool 
    }
  }
}"

"
y = true
if bool then do:
  x = 0
end"


class DnD

    def initialize
        @dndParser = Parser.new("DnD") do
          @variables = {}

          token(/\s+/)
          #token(/\d+/) {|m| m.to_i }
          token(/True/) { |m| m}
          token(/False/) { |m| m}

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
            match(:boolean)
            match(:varset)
          end

          rule :boolean do
              match(:boolean, "||", :and) {|a, _, b| LogicNode.new a, "or", b}
              match(:and)
          end
          
          rule :and do
            match(:and, "&&", :relation) {|a, _, b| LogicNode.new a, "and", b}
            match(:relation)
          end
          
          rule :relation do
            match(:relation, "!=", :addition) { |a, _, b| SymbolNode.new a, :!=, b} 
            match(:relation, "=", "=", :addition) { |a, _, _, b| SymbolNode.new a, :==, b} 
            match(:relation, "<", "=", :addition) { |a, _, _, b| SymbolNode.new a, :<=, b} 
            match(:relation, ">", "=", :addition) { |a, _, _, b| SymbolNode.new a, :>=, b} 
            match(:relation, "<", :addition) { |a, _, b| SymbolNode.new a, :<, b}  
            match(:relation, ">", :addition) { |a,  _, b| SymbolNode.new a, :>, b} 
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
            match('True') { |a| ValueNode.new true}
            match('False') {|a| ValueNode.new false}
            match(:var)
            #match("(", :boolean, ")")
          end
          
          rule :var do
            match(:float)
            match(:int)
            match(:char)
            match(:varget)
            #match(:list)
          end

          rule :float do
            match(Integer, ".", Integer)  { |a, _, b| ValueNode.new((a.to_s + "." + b.to_s).to_f)}
          end

          rule :int do
            match(Integer) { |a| ValueNode.new a}
          end

          rule :char do
            match(Char) {|a| ValueNode.new a.value} 
          end

          rule :identifier do
            match(Variable) {|a| a.name }
          end

          rule :varget do 
            match(:identifier) {|a| VariableNode.new a, @variables}
          end

          rule :varset do
            match(:primitive, :identifier, '=', :boolean) {|a, b, _, c| VariableSetNode.new b, a, c, @variables} # @variables[b] = {:type => a, :value => c}}
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
            @diceParser.logger.level = Logger::DEBUG
        else
            @diceParser.logger.level = Logger::WARN
        end
    end
end

#DnD.new.parse