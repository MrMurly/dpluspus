require 'rdparse.rb'

class DnD

    def initialize
        @language = Parser.new("DnD") do
          token(/\s+/)
          token(/\d+/) {|m| m.to_i }
          token(/./) {|m| m }
          
            
          end
        end
      end


end