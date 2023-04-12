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
          #token(/[\(\)\[\]\{\}]/) { |m| m}
          token(/main/) { |m| :_main}
          token(/print/) {|m| :_print}
          token(/class/) { |m| :_class}
          token(/new/) { |m| :_new}

          token(/if/) { |m| :_if}
            token(/else/) { |m| :_else}
          token(/True/) { |m| :_true}
          token(/False/) { |m| :_false}
          token(/for/) { |m| :_for}
          token(/while/) { |m| :_while}

          token(/char/) {|m| :_char}
          token(/int/) {|m| :_int}
          token(/float/) {|m| :_float}
          token(/bool/) {|m| :_bool}
          token(/string/) {|m| :_string}
          token(/void/) {|m| :_void}
          
          token(/\d+/) {|m| m.to_i}
          token(/\W/) {|m| m}
          token(/\w+/) {|m| m} 

          start :main do
<<<<<<< HEAD
            match(:_int, :_main, '(', ')', :block) { |_, _, _, _, a| a }
=======
            match('int', 'main', '(', ')', :block) { |_, _, _, _, a| a }
            match(:class, :main ) {|a, b| MainNode.new(a, b)}
>>>>>>> 3bc8f3e (reworked how classes work based on feedback)
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
            match(:_print, '(', :boolean, ')') {|_, _, a, _| PrintNode.new(a)}
            match(:_print, '(', :findelement, ')') {|_, _, a, _| PrintNode.new(a)}
          end
          #END


          #CLASSES
          
          rule :class do 
            match('class', :identifier, '{', :classvarblock, ';', :classfuncblock, '}') { |_, a, _, b, _, c, _| ClassNode.new(a, b, c)}
            match('class', :identifier, '{', :classfuncblock, '}') { |_, a, _, b, _, c, _| ClassNode.new(a, b, c)}
            match('class', :identifier, '{', :classvarblock, '}') { |_, a, _, b, _, c, _| ClassNode.new(a, b, c)}
            match('class', :identifier, '{' '}') { |_, a, _, b, _, c, _| ClassNode.new(a, b, c)}
            
          end

          rule :classvarblock do
            match(:primitive, :identifier, ";", :classvarblock) {|a, b, _, c| ClassBlockVarNode.new(a, b, c)}
            match(:primitive, :identifier, ";") {|a, b, _| ClassBlockVarNode.new(a, b, nil)} 
          end

          rule :classfuncblock do
            match(:primitive, :identifier, '(', :params, ')', :block, :classfuncblock) { |a, b, _, c, _, d, e| ClassBlockFuncNode.new(a, b, c, d, e) }
            match(:primitive, :identifier, '(', :params, ')', :block) {|a, b, _, c, _, d| ClassBlockFuncNode.new(a, b , c, d, nil)}
          end
          
          # class car { ..... }
          # car Volvo;
          # car Volvo = new Car(12,3,3,3,3,45,1241);
          rule :classinit do 
            match('new', ClassIdentity, '(', :callparams, ')') {|_, a, _, b, _| ClassInitNode.new(a, b)} #parameters and class initalisation
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
            match(:callparams, ",", :boolean) {|a, _, b| ParamNode.new(a, b)}
            match(:boolean) {|a| [a]}
          end
          #END

          #LOOPS
          rule :while do
            match(:_while, "(", :boolean, ")", :block) {|_, _, a, _, b| LoopNode.new(nil, nil, a, b)}
          end
          
          rule :for do
            match(:_for, "(", :varset, ";",  :varset, ";", :boolean,")", :block) {|_,_, a, _, b, _, c, _, d| LoopNode.new(a, b, c, d)}
          end
          #END

          #COMPLEX DATA TYPES
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

          #END

          #IF-STATEMENTS
          rule :if do 
            match(:_if, '(', :boolean, ')', :block, :else) {|_,_, a, _, b, c| IfElseNode.new(a, b, c)}
            match(:_if, '(', :boolean, ')', :block) {|_,_, a, _, b| IfNode.new(a, b)}
          end

          rule :else do
            match(:_else, 'if', '(', :boolean, ')', :block, :else) {|_, _, _, a, _, b, c| IfElseNode.new(a, b, c)}
            match(:_else, 'if', '(', :boolean, ')', :block) {|_, _, _, a, _, b| IfNode.new(a, b)}
            match(:_else, :block) {|_, a| a}
          end
          #END

          #LOGIC/ARITEMIK
          rule :boolean do
              match(:boolean, "|", "|", :and) {|a, _, b| LogicNode.new a, "or", b}
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
            match("'", /./, "'") {|_, a, _| ValueNode.new a, "char"} 
          end

          rule :identifier do
            match(/\A[a-z]\w*/) {|a| a }
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
            match(:_char) { "char" }
            match(:_int) { "int" }
            match(:_float) { "float" }
            match(:_bool) { "bool" }
            match(:_string) { "string" }
            match(:_void) { "void" }
            match(/\A[A-Z]\w*/) { |a| a }
          end
          
          rule :name do
            match(/\A[a-zA-Z]\w*/)
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