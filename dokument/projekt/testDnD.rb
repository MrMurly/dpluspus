require './grammar'
require 'test/unit'

# doc = Dir["./tests/*.dpp"]

# p doc

class TestMain < Test::Unit::TestCase
    def testMain
        parser = DnD.new
        parser.log true

        # Dir["./tests/*.dpp"].each { |f| 
        #     file = File.open(f) 
        #     parser.testParse(file.read)
        #     file.close
        # }
        file = File.open("./tests/list.dpp")
        parser.testParse(file.read)
        file.close
    end

end
