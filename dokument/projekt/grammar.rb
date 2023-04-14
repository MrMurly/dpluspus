require './rdparse'
Dir["./ast/*.rb"].each { |file| require file } 

class Variable
  attr_reader :name
  def initialize name
    @name = name
  end
end

class ClassIdentity
  attr_reader :name
  def initialize name
    @name = name
  end
end

class Char
  attr_reader :value
  def initialize value
    @value = value.delete "'"
  end
end


class DnD

    def initialize
        Node.new.clearStackFrame
        @dndParser = Parser.new("DnD") do
          # @variables = {}

          token(/\s+/)
          #token(/\d+/) {|m| m.to_i }
          token(/main/) { |m| m}
          token(/print/) {|m| m}
          token(/class/) { |m| m}
          token(/new/) { |m| m}

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
          token(/[A-Z]\w*/) {|m| ClassIdentity.new m}
          token(/[a-z]\w*/) {|m| Variable.new m}
          token(/\d+/) {|m| m.to_i}
          token(/./) {|m| m }

          start :main do
            match('int', 'main', '(', ')', :block) { |_, _, _, _, a| a }
            match(:function, :main) {|a, b| MainNode.new(a, b)}
          end

          #BLOCK
          rule :block do
            match('{', :statements, '}') {|_, a, _| BlockNode.new(a)}
            match('{','}') {|_, _| BlockNode.new }
          end

          rule :statements do
            match(:statement, ';', :statements) {|a, _, b| StatementNode.new(a, b)}
            match(:statement, ';') {|a, _| a}
          end

          rule :statement do
            match(:call)
            match(:list)
            match(:findelement)
            match(:string)
            match(:varset)
            match(:if)
            match(:boolean)
            match(:for)
            match(:while)
            # match(:return)
            match(:print)
            
          end


          # rule :return do
          #   match('return', :boolean) {|_, a| ReturnNode.new(a)}
          # end    
          
          rule :print do 
            match('print', '(', :boolean, ')') {|_, _, a, _| PrintNode.new(a)}
            match('print', '(', :findelement, ')') {|_, _, a, _| PrintNode.new(a)}
          end
          #END


          #CLASSES
          
          # rule :class do 
          #   match('class', Variable, '{', :classblock, '}') { |_, a, _, b, _| ClassNode.new(a, b)}
          # end

          # rule :classblock do
          #   match(:function, :classblock) {|a, b| ClassBlockFuncNode.new(a, b)}
          #   match(:primitive, :identifier, ";", :classblock) {|a, b, _, c| ClassBlockVarNode.new(a, b, c)}
          #   match(:function) 
          #   match(:primitive, :identifier, ";") {|a, b, _| ClassBlockVarNode.new(a, b, nil)} 
          # end
          
          # # class car { ..... }
          # # car Volvo;
          # # car Volvo = new Car(12,3,3,3,3,45,1241);
          # rule :classinit do 
          #   match('new', ClassIdentity, '(', :callparams, ')') {|_, a, _, b, _| ClassInitNode.new(a, b)} #parameters and class initalisation
          # end

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
            match(:callparams, ",", :boolean) {|a, _, b| ParamNode.new(a, b)}
            match(:boolean) {|a| [a]}
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

          #COMPLEX DATA TYPES

          #list
          rule :list do
            match(:primitive, "[", "]", :identifier, "=" ,"[", :members, "]") {|a, _, _, b, _, _, c, _| ListNode.new(a, b, c)}
            match(:primitive, "[", "]", :identifier, "=", "[","]") {|a, _ ,_, b, _, _, _| ListNode.new(a, b, nil)}
            match(:primitive, "[", "]", :identifier) {|a, _, _, b| ListNode.new(a, b, nil)}
          end


          rule :members do
            match(:members, ",", :member) {|a, _, b| MemberNode.new(a, b)}
            match(:member) {|a| MemberNode.new(a, nil)}
          end

          rule :member do
            match(:var) {|a| [a]}
          end

          rule :findelement do
            match(:identifier, "[", :int, "]") {|a, _, b, _| FindElementNode.new(a, b)}
          end

          #string
          rule :string do
            match("\"", :characters, "\"") {|_, a, _| StringNode.new(a)}
          end

          rule :characters do
            match(:characters, :character) {|a, b| CharacterNode.new(a, b)}
            match(:character) {|a| CharacterNode.new(a, nil)}
          end

          rule :character do
            match(:var) {|a| [a]}
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
            match(:identifier, '=', :varset2) {|a, _, b| VariableAssignmentNode.new a, b}
            match(:primitive, :identifier, '=', :varset2) {|a, b, _, c| VariableSetNode.new b, a, c} 
          end

          rule :varset2 do
            match(:boolean)
          end



          rule :primitive do
            match('char')
            match('int')
            match('float')
            match('bool')
            match('string')
            match('void')
            match(ClassIdentity) { |a| a.name }
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