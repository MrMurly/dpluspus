require './grammar'
require 'test/unit'

# doc = Dir["./tests/*.dpp"]

# p doc

class TestMain < Test::Unit::TestCase
    def testMain
        parser = DnD.new
        parser.log false

        Dir["./tests/*.dpp"].each { |f| 
            puts f
            file = File.open(f).read
            Dir["./std/*.dpp"].each { |f2|
                file = File.open(f2).read + file   
            }
            parser.testParse(file)
        }
        # file = File.open("./tests/list.dpp")
        # parser.testParse(file.read)
        # file.close
    end

end
