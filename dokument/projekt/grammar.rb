require './rdparse'
Dir["./ast/*.rb"].each { |file| require file } 

class DnD

    def initialize
        Node.new.clearStackFrame
        @dndParser = Parser.new("DnD") do

          token(/\s+/)
          token(/main/) { |m| :_main}
          token(/print/) {|m| :_print}
          token(/class/) { |m| :_class}
          token(/new/) { |m| :_new}
          token(/return/) { |m| :_return}

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
            match(:_int, :_main, '(', ')', :block) { |_, _, _, _, a| a }
            match(:function, :main) {|a, b| MainNode.new(a, b)}
            match(:class, :main) {|a, b| MainNode.new(a, b)}
          
          end

          #BLOCK
          rule :block do
            match('{', :statements, '}') {|_, a, _| BlockNode.new(a)}
            match('{','}') {|_, _| BlockNode.new }
          end

          rule :statements do
            match(:statement, ';', :statements) {|a, _, b| 
              StatementNode.new(a, b)
            }
            match(:statement, ';') {|a, _| a}
          end

          rule :statement do
            match(:list)
            match(:varset)
            match(:if)
            match(:boolean)
            match(:for)
            match(:while)
            match(:return)
            match(:print)
            
          end
  
          
          rule :print do 
            match(:_print, '(', :boolean, ')') {|_, _, a, _| PrintNode.new(a)}
          end


          rule :return do
            match(:_return, :boolean) {|_, a| ReturnNode.new(a)}
          end
          #END




          #CLASSES
          
          rule :class do 
            match(:_class, :classIdentifier, '{', :classvarblock, 
              :classconstructor, :classfuncblock, '}') { |_, a, _, b, c, d, _| 
                ClassNode.new(a, b, c, d)
              }
            match(:_class, :classIdentifier, '{', :classconstructor,
              :classfuncblock, '}') { |_, a, _, b, c, _| 
                ClassNode.new(a, b, c)
              }
            match(:_class, :classIdentifier, '{', :classconstructor, 
              :classvarblock, '}') { |_, a, _, b, c, _| 
                ClassNode.new(a, b, c)
              }
            match(:_class, :classIdentifier, '{' '}') { |_, a, _, b, _, c, _| 
              ClassNode.new(a, b, c)
            }
          end

          rule :classconstructor do
            match(:classIdentifier, :_params, :block, ';') { |a, b, c| 
              ClassConstructorNode.new(a, b, c)
            }
          end

          rule :classvarblock do
            match(:primitive, :identifier, ";", :classvarblock) {|a, b, _, c| 
              ClassBlockVarNode.new(a, b, c)
            }
            match(:primitive, :identifier, ";") {|a, b, _| 
              ClassBlockVarNode.new(a, b, nil)
            } 
            match(:primitive, "[", "]", :identifier, ';', :classvarblock) {
              |a, _, _, b, _, c| ClassBlockVarNode.new(a, b, c, true)
            }
            match(:primitive, "[", "]", :identifier) {|a, _, _, b| 
              ClassBlockVarNode.new(a, b, nil, true)
            }
          end

          rule :classfuncblock do
            match(:primitive, :identifier, :_params, :block, ';', 
              :classfuncblock) { |a, b, c, d, _, e| 
                ClassBlockFuncNode.new(a, b, c, d, e) 
              }
            match(:primitive, :identifier, :_params, :block, ';') {
              |a, b, c, d, _| ClassBlockFuncNode.new(a, b , c, d, nil)
            }
          end

          rule :_params do 
            match('(', ')') {[]}
            match('(', :params, ')') {|_, a, _| a}
          end
          
          rule :classinit do 
            match(:_new, :classIdentifier, '(', :callparams, ')') {
              |_, a, _, b, _| ClassInitNode.new(a, b)
            } 
            match(:_new, :classIdentifier, '(',')') { 
              |_, a, _, _ | ClassInitNode.new(a, nil)
            } 
          end

          rule :classIdentifier do
            match(/\A[A-Z]\w*/) {|a| a }
          end

          rule :classmethod do 
            match(:identifier, '.', :identifier, '(', ')') { 
              |a, _, b| ClassMethodCallNode.new(a, b, nil)
            }
            match(:identifier, '.', :identifier, '(', :callparams, ')') {
              |a, _, b, _, c| ClassMethodCallNode.new(a, b, c)
            }
          end 

          #END

          #FUNCTIONS
          rule :function do
            match(:primitive, :identifier, "(", :params, ")", :block) {
              |a, b, _, c, _, d| DeclareFuncNode.new(a, b, c, d)
            }
            match(:primitive, :identifier, "(", ")", :block) {
              |a, b, _, _, d| DeclareFuncNode.new(a, b, nil, d)
            }
          end

          rule :call do
            match(:identifier, "(", :callparams, ")") { 
              |a, _, b, _| FuncCallNode.new(a, b)
            }
            match(:identifier, "(", ")") {
              |a, _, _| FuncCallNode.new(a, nil)
            }
          end

          rule :params do
            match(:params, ",", :param) {|a, _, b| ParamNode.new(a, b)}
            match(:param) 
          end

          rule :param do
            match(:primitive, :identifier) {|a, b| [{:name => b, :type => a}]}
          end
          
          rule :callparams do 
            match(:callparams, ",", :boolean) {|a, _, b| ParamNode.new(a, [b])}
            match(:boolean) {|a| [a]}
          end
          #END

          #LOOPS
          rule :while do
            match(:_while, "(", :boolean, ")", :block) {|_, _, a, _, b| 
              LoopNode.new(nil, nil, a, b)
            }
          end
          
          rule :for do
            match(:_for, "(", :varset, ";",  :varset, ";", :boolean,")", 
            :block) {|_,_, a, _, b, _, c, _, d| LoopNode.new(a, b, c, d)}
          end
          #END

          #COMPLEX DATA TYPES

          #list
          rule :list do
            match(:primitive, "[", "]", :identifier, "=" , :primlist) {
              |a, _, _, b, _, c| ListNode.new(a, b, c)
            }
            match(:primitive, "[", "]", :identifier, "=", "[","]") {
              |a, _ ,_, b, _, _, _| ListNode.new(a, b, nil)
            }
            match(:primitive, "[", "]", :identifier) {|a, _, _, b| 
              ListNode.new(a, b, nil)
            }
          end

          rule :primlist do 
            match("[", :members, "]") { |_, a, _| ValueListNode.new(a)}
          end

          rule :members do
            match(:members, ",", :member) {|a, _, b| MemberNode.new(a, b)}
            match(:member) {|a| MemberNode.new(a, nil)}
          end

          rule :member do
            match(:var) {|a| [a]}
          end

          rule :findelement do
            match(:identifier, "[", :int, "]") {|a, _, b, _| 
              FindElementNode.new(a, b)
            }
          end

          #IF-STATEMENTS
          rule :if do 
            match(:_if, '(', :boolean, ')', :block, :else) {
              |_,_, a, _, b, c| IfElseNode.new(a, b, c)
            }
            match(:_if, '(', :boolean, ')', :block) {
            |_,_, a, _, b| IfNode.new(a, b)
            }
          end

          rule :else do
            match(:_else, :_if, '(', :boolean, ')', :block, 
            :else) {|_, _, _, a, _, b, c| IfElseNode.new(a, b, c)}
            
            match(:_else, :_if, '(', :boolean, ')', :block) {|_, _, _, a, _, b|
            IfNode.new(a, b)}
            
             match(:_else, :block) {|_, a| a}
          end
          #END

          #LOGIC/ARITEMIK
          rule :boolean do
              match(:boolean, "|", "|", :and) {|a, _, b| 
              LogicNode.new(a, "or", b)}
              
              match(:and)
          end
          
          rule :and do
            match(:and, "&&", :relation) {|a, _, b| LogicNode.new(a, "and", b)}
            match(:relation)
          end
          
          rule :relation do
            match(:relation, "!=", :addition) { |a, _, b| 
            LogicNode.new(a, :!=, b)} 
            
            match(:relation, "=", "=", :addition) { |a, _, _, b| 
            LogicNode.new(a, :==, b)} 
            
            match(:relation, "<", "=", :addition) { |a, _, _, b| 
            LogicNode.new(a, :<=, b)} 
            
            match(:relation, ">", "=", :addition) { |a, _, _, b|
            LogicNode.new(a, :>=, b)} 
            
            match(:relation, "<", :addition) { |a, _, b| 
            LogicNode.new(a, :<, b)}  
            
            match(:relation, ">", :addition) { |a,  _, b| 
            LogicNode.new(a, :>, b)}
            
            match(:addition)
          end
          
          rule :addition do
            match(:addition, '+', :multi) {|a, _, b| SymbolNode.new(a, :+, b)}
            match(:addition, '-', :multi) {|a, _, b| SymbolNode.new(a, :-, b)}
            match(:multi)
          end

          rule :multi do
            match(:term, '^', :multi) { |a, _, b| SymbolNode.new(a, :**, b) }
            match(:multi, '/', :term) { |a, _, b| SymbolNode.new(a, :/, b) }
            match(:multi, '*', :term) { |a, _, b| SymbolNode.new(a, :*, b) } 
            match(:multi, '%', :term) { |a, _, b| SymbolNode.new(a, :%, b) }
            match(:term)
          end

          rule :term do
            match("(", :boolean, ")") {|_, a, _| a}
            match('True') { |a| ValueNode.new(true, "bool")}
            match('False') {|a| ValueNode.new(false, "bool")}
            match(:var)
          end
          
          rule :var do
            match(:classmethod)
            match(:call)
            match(:float)
            match(:int)
            match(:char)
            match(:string)
            match(:primlist)
            match(:varget)
          end
          
          rule :string do
            match("\"", /.*/, "\"") {|_, a, _| ValueNode.new(a, "string")}
          end
          
          rule :float do
            match(Integer, ".", Integer)  { |a, _, b| 
            ValueNode.new((a.to_s + "." + b.to_s).to_f, "float") }
          end

          rule :int do
            match(Integer) { |a| ValueNode.new(a, "int")}
          end

          rule :char do
            match("'", /./, "'") {|_, a, _| ValueNode.new(a, "char")} 
          end

          rule :identifier do
            match(/\A[a-z]\w*/) {|a| a }
          end

          rule :varget do 
            match(:findelement)
            match(:identifier, '.', :identifier, '[', :var,']') {
            |a, _, b, _, c, _| ClassElemNode.new(a, b, c)
            }
            
            match(:identifier, '.', :identifier) { 
            |a, _, b| ClassVarNode.new(a, b)
            }
            
            match(:identifier) {|a| VariableNode.new a}
          end

          rule :varset do
            match(:identifier, '.', :identifier, '=', :varset2) { 
            |a, _, b, _, c| ClassVarAssignmentNode.new(a, b, c)
            }
            
            match(:identifier, '=', :varset2) {
              |a, _, b| VariableAssignmentNode.new(a, b)
            }
            
            match(:primitive, :identifier, '=', :varset2) {
            |a, b, _, c| VariableSetNode.new(b, a, c)
            } 
          end

          rule :varset2 do
            match(:classinit)
            match(:boolean)
          end



          rule :primitive do
            match(:_char) { "char" }
            match(:_int) { "int" }
            match(:_float) { "float" }
            match(:_bool) { "bool" }
            match(:_string) { "string" }
            match(:_void) { "void" }
            match(:primitive, '[', ']')
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
        puts "=> #{@dndParser.parse(File.open(str).read).evaluate}"
        parse
      end
    end

    def testParse str
      res = @dndParser.parse(str)
      if res == nil
        raise "error, #{res} is nil"
      end
      res.evaluate
    end

    def log(state = true)
        if state
            @dndParser.logger.level = Logger::DEBUG
        else
            @dndParser.logger.level = Logger::WARN
        end
    end
end

#DnD.new.parse