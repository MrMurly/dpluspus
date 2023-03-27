require './rdparse'

class DnD

    def initialize
        @dndParser = Parser.new("DnD") do
          @variables = {"foo" => {
            "type"=>"string",
            "value"=>"bar"
          }}

          token(/\s+/)
          # token(/\d+/) {|m| m.to_i }
          token(/./) {|m| m }

          # start :expr do 
          #   match(:expr, '+', :term) {|a, _, b| a + b }
          #   match(:expr, '-', :term) {|a, _, b| a - b }
          #   match(:term)
          # end
          
          # rule :term do 
          #   match(:term, '*', :dice) {|a, _, b| a * b }
          #   match(:term, '/', :dice) {|a, _, b| a / b }
          #   match(:dice)
          # end
    
          
          # rule :sides do
          #   match('%') { 100 }
          #   match(:atom)
          # end
          start :begin do 
            match(:boolean)
            match(:varset)
          end


          rule :boolean do
              match(:boolean, "||", :and) {|a, _, b| a or b}
              match(:and)
          end
          
          rule :and do
            match(:and, "&&", :relation) {|a, _, b| a and b}
            match(:relation)
          end
          
          rule :relation do
            match(:relation, "!=", :addition) { |a, _, b| a != b} 
            match(:relation, "==", :addition) { |a, _, b| a == b} 
            match(:relation, "<", :addition) { |a, _, b| a < b}  
            match(:relation, ">", :addition) { |a,  _, b| a > b} 
            match(:relation, "<=", :addition) { |a, _, b| a <= b} 
            match(:relation, ">=", :addition) { |a, _, b| a >= b} 
            match(:addition)
          end
          
          rule :addition do
            match(:addition, '+', :multi) {|a, _, b| a + b}
            match(:addition, '-', :multi) {|a, _, b| a - b}
            match(:multi)
          end

          rule :multi do
            match(:term, '^', :multi) { |a, _, b| a ** b} 
            match(:multi, '/', :term) { |a, _, b| a / b}
            match(:multi, '%', :term) { |a, _, b| a % b}
            match(:term)
          end

          rule :term do
            match("(", :boolean, ")") 
            match('True') { |a| true}
            match('False') {|a| false}
            match(:var)
            #match("(", :boolean, ")")
          end
          
          rule :var do
            match(:identifier)
            match(:float)
            match(:int)
            match(:char)
            #match(:list)
          end

          rule :float do
            match(:int, ".", :int)  { |a, _, b| (a.to_s + "." + b.to_s).to_f}
          end

          rule :int do
            match(/\d+/) { |a| a.to_i }
          end

          rule :char do
            match("'", /\w/, "'") {|_, a, _| a.to_s}
          end

          rule :identifier do
            match(/[a-zA-Z]\w+/) {|a| @variables[a]}
          end

          rule :varset do
            match(:primitive, :identifier, '=', :var) {|a, b, _, c| @variables[b] = {:type => c, :value => a}}
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
            match(/[a-zA-Z]\w+/)
          end

        end
      end
      
    def done(str)
        ["quit","exit","bye","done",""].include?(str.chomp)
    end
    
    def parse
        print "[diceroller] "
        str = gets
        if done(str) then
            puts "Bye."
        else
            puts "=> #{@dndParser.parse str}"
            parse
        end
    end

    def log(state = true)
        if state
            @diceParser.logger.level = Logger::DEBUG
        else
            @diceParser.logger.level = Logger::WARN
        end
    end
end

DnD.new.parse