require './grammar'
require 'test/unit'

class TestAritmethic < Test::Unit::TestCase
    def testTerm
        parser = DnD.new
        parser.log false
        assert_equal(parser.testParse("False"), false)
        assert_equal(parser.testParse("True"), true)
    end

    def testMulti
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("12 % 4"), 0)
        assert_equal(parser.testParse("12 % 5"), 2)
        
        assert_equal(parser.testParse("2 * 2"), 4)
        assert_equal(parser.testParse("2 * 5 * 2"), 20)
        assert_equal(parser.testParse("10.0 * 0.2"), 2)

        assert_equal(parser.testParse("10 / 2"), 5)
        assert_equal(parser.testParse("256 / 2"), 128)
        assert_equal(parser.testParse("100.0 / 0.5"), 200)

        assert_equal(parser.testParse("2^2"), 4)
        assert_equal(parser.testParse("2^6"), 64)
        assert_equal(parser.testParse("2^0"), 1)
        assert_equal(parser.testParse("2^2^2"), 16)
        
    end
    def testAddition
        parser = DnD.new 
        parser.log false
        assert_equal(parser.testParse("1 + 2"), 3)
        assert_equal(parser.testParse("55 + 65"), 120)

        assert_equal(parser.testParse("1.2 + 1.3"), 2.5)
        assert_equal(parser.testParse("3.14159 + 6.96951"), 10.1111)
        assert_equal(parser.testParse("0.5 + 1.0"), 1.5)

        assert_equal(parser.testParse("2 - 1"), 1)
        assert_equal(parser.testParse("100 - 200"), -100)

        assert_equal(parser.testParse("1.9 - 0.5"), 1.4)
        assert_equal(parser.testParse("0.5 - 1.0"), -0.5)
    end

    
end


class TestLogic < Test::Unit::TestCase
    def testEquals
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("True != True"), false)
        assert_equal(parser.testParse("True != False"), true)

        assert_equal(parser.testParse("True == True"), true)
        assert_equal(parser.testParse("True == False"), false)
        
        assert_equal(parser.testParse("1 < 1"), false)
        assert_equal(parser.testParse("0 < 1"), true)
        
        assert_equal(parser.testParse("1 > 1"), false)
        assert_equal(parser.testParse("1 > 0"), true)

        assert_equal(parser.testParse("1 <= 1"), true)
        assert_equal(parser.testParse("1 <= 0"), false)        
    end
    
    def testAnd
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("True && True"), true)
        assert_equal(parser.testParse("True && False"), false)
        assert_equal(parser.testParse("False && False"), false)
        
        assert_equal(parser.testParse("False == False && True == True"), true)
    end
    
    def testOr
        parser = DnD.new
        parser.log false
        assert_equal(parser.testParse("True || True"), true)
        assert_equal(parser.testParse("True || False"), true)
        assert_equal(parser.testParse("False || False"), false)

        assert_equal(parser.testParse("False && False || False && True || True"), true)
    end



end

class Variables < Test::Unit::TestCase
    def testVari
        parser = DnD.new
        parser.log false

        parser.testParse("char a = '1'")
    
        parser.testParse("int a = 0")
        assert_equal(parser.testParse("a != 1"), true)
        assert_equal(parser.testParse("a == 0"), true)

        parser.testParse("float b = 1.5")
        assert_equal(parser.testParse("b == 1.5"), true)

        parser.testParse("bool c = True")
        assert_equal(parser.testParse("c != False"), true)

        parser.testParse("int a = a + 1")
        assert_equal(parser.testParse("a == 1"), true)

        parser.testParse("int b = 0")
        parser.testParse("b = 1")
        assert_equal(parser.testParse("b"), 1)
        
        parser.testParse("int a = 0")
        parser.testParse("a = a + 1")
        assert_equal(parser.testParse("a"), 1)
    end
end    

class If < Test::Unit::TestCase
    def testIfstatement
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("if (True) {}"), nil)

        assert_equal(parser.testParse("
        if (True) {
            int a = 1;
        }"
        ), {}) 
    end

    def testElseIf
        parser = DnD.new
        parser.log false
        assert_equal(parser.testParse("if (True) {}"), nil)

        assert_equal(parser.testParse("
        if (False) {
            int a = 1;
        } 
        else if (True) {
            int a = 2;
        }"
        ), {:prev = {}, "a"=>})
    end

    def testElse
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("
            if (False) {

            }
            else {
                bool a = True;
            }
        "), {})
    end
end

#        else {int a = 1;}
class Block < Test::Unit::TestCase
    def testStatements
        parser = DnD.new
        parser.log false
        
    end

    def testStackFrame
        parser = DnD.new
        parser.log false
        
        assert_equal(parser.testParse("
            {
                int a = 0;
                if (true) {
                    a = 1;
                };
            }
        "), {})

    end
end
    