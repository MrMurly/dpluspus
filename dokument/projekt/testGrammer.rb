require './grammar'
require 'test/unit'

class TestAritmethic < Test::Unit::TestCase
    def testTerm
        parser = DnD.new
        parser.log false
        assert_equal(parser.testParse("False"), {:value => false, :type => "bool"})
        assert_equal(parser.testParse("True"), {:value => true, :type => "bool"})
    end

    def testMulti
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("12 % 4"), {:value => 0, :type => "int"})
        assert_equal(parser.testParse("12 % 5"), {:value => 2, :type => "int"})
        
        assert_equal(parser.testParse("2 * 2"), {:value => 4, :type => "int"})
        assert_equal(parser.testParse("2 * 5 * 2"), {:value => 20, :type => "int"})
        assert_equal(parser.testParse("10.0 * 0.2"), {:value => 2.0, :type => "float"})

        assert_equal(parser.testParse("10 / 2"), {:value => 5, :type => "int"})
        assert_equal(parser.testParse("256 / 2"), {:value => 128, :type => "int"})
        assert_equal(parser.testParse("100.0 / 0.5"), {:value => 200.0, :type => "float"})

        assert_equal(parser.testParse("2^2"), {:value => 4, :type => "int"})
        assert_equal(parser.testParse("2^6"), {:value => 64, :type => "int"})
        assert_equal(parser.testParse("2^0"), {:value => 1, :type => "int"})
        assert_equal(parser.testParse("2^2^2"), {:value => 16, :type => "int"})
        
    end
    def testAddition
        parser = DnD.new 
        parser.log false
        assert_equal(parser.testParse("1 + 2"), {:type => "int", :value => 3})
        assert_equal(parser.testParse("55 + 65"), {:value => 120, :type => "int"})

        assert_equal(parser.testParse("1.2 + 1.3"), {:value => 2.5, :type => "float"})
        assert_equal(parser.testParse("3.14159 + 6.96951"), {:value => 10.1111, :type => "float"})
        assert_equal(parser.testParse("0.5 + 1.0"), {:value => 1.5, :type => "float"})

        assert_equal(parser.testParse("2 - 1"), {:value => 1, :type => "int"})
        assert_equal(parser.testParse("100 - 200"), {:value => -100, :type => "int"})

        assert_equal(parser.testParse("1.9 - 0.5"), {:value => 1.4, :type => "float"})
        assert_equal(parser.testParse("0.5 - 1.0"), {:value => -0.5, :type => "float"})
    end

    
end


class TestLogic < Test::Unit::TestCase
    def testEquals
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("True != True"), {:value => false, :type => "bool"})
        assert_equal(parser.testParse("True != False"), {:value => true, :type => "bool"})

        assert_equal(parser.testParse("True == True"), {:value => true, :type => "bool"})
        assert_equal(parser.testParse("True == False"), {:value => false, :type => "bool"})
        
        assert_equal(parser.testParse("1 < 1"), {:value => false, :type => "bool"})
        assert_equal(parser.testParse("0 < 1"), {:value => true, :type => "bool"})
        
        assert_equal(parser.testParse("1 > 1"), {:value => false, :type => "bool"})
        assert_equal(parser.testParse("1 > 0"), {:value => true, :type => "bool"})

        assert_equal(parser.testParse("1 <= 1"), {:value => true, :type => "bool"})
        assert_equal(parser.testParse("1 <= 0"), {:value => false, :type => "bool"})        
    end
    
    def testAnd
        parser = DnD.new
        parser.log false

        assert_equal(parser.testParse("True && True"), {:value => true, :type => "bool"})
        assert_equal(parser.testParse("True && False"), {:value => false, :type => "bool"})
        assert_equal(parser.testParse("False && False"), {:value => false, :type => "bool"})
        
        assert_equal(parser.testParse("False == False && True == True"), {:value => true, :type => "bool"})
    end
    
    def testOr
        parser = DnD.new
        parser.log false
        assert_equal(parser.testParse("True || True"), {:value => true, :type => "bool"})
        assert_equal(parser.testParse("True || False"), {:value => true, :type => "bool"})
        assert_equal(parser.testParse("False || False"), {:value => false, :type => "bool"})

        assert_equal(parser.testParse("False && False || False && True || True"), {:value => true, :type => "bool"})
    end



end

class Variables < Test::Unit::TestCase
    def testVari
        parser = DnD.new
        parser.log false

        parser.testParse("char a = '1'")
    
        parser.testParse("int a = 0")
        assert_equal(parser.testParse("a != 1"), {:value=> true, :type => "bool"})
        assert_equal(parser.testParse("a == 0"), {:value=> true, :type => "bool"})

        parser.testParse("float b = 1.5")
        assert_equal(parser.testParse("b == 1.5"), {:value=> true, :type => "bool"})

        parser.testParse("bool c = True")
        assert_equal(parser.testParse("c != False"), {:value=> true, :type => "bool"})

        parser.testParse("int a = a + 1")
        assert_equal(parser.testParse("a == 1"), {:value=> true, :type => "bool"})

        parser.testParse("int b = 0")
        parser.testParse("b = 1")
        assert_equal(parser.testParse("b"), {:value => 1, :type => "int"})
        
        parser.testParse("int a = 0")
        parser.testParse("a = a + 1")
        assert_equal(parser.testParse("a"), {:value => 1, :type => "int"})
        parser.testParse("a = a + 1")
        parser.testParse("a = a + 1")
        parser.testParse("a = a + 1")
        parser.testParse("a = a + 1")
        parser.testParse("a = a + 1")
        assert_equal(parser.testParse("a"), {:value => 6, :type => "int"})

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
        ), {})
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
                if (True) {
                    a = 1;
                };
            }
        "), {})

    end
end

class Function < Test::Unit::TestCase
    def testDeclaringFunc
        parser = DnD.new
        parser.log false
        func = parser.testParse("
        int test() {
            int a = 0;
        }
        ")

        assert_equal(func[:block].is_a?(BlockNode), true)
        assert_equal(func[:parameters], nil)
        assert_equal(func[:returnType], "int")
    end

    def testCallingFunc
        parser = DnD.new
        parser.log false

        parser.testParse("int a = 0")
        assert_equal(parser.testParse("a == 0"), {:type=>"bool", :value=>true})

        parser.testParse("
        int heltal() {

            a = 12;
        } 
        ")
        parser.testParse("heltal()")
        assert_equal(parser.testParse("a == 12"), {:type=>"bool", :value=>true})


    end

    def diffParameters
        parser = DnD.new
        parser.log false
        parser.testParse("int a = 0")
        assert_equal(parser.testParse("a == 0"), {:type=>"bool", :value=>true})

        parser.testParse("
        int heltal(int tal) {

            a = tal;
        } 
        ")
        parser.testParse("heltal(12)")
        assert_equal(parser.testParse("a == 12"), {:type=>"bool", :value=>true})

        parser.testParse("char b = 'p'")
        assert_equal(parser.testParse("b == 'p'"), {:type=>"bool", :value=>true})

        parser.testParse("
        int heltal(char character) {

            b = character;
        } 
        ")
        parser.testParse("heltal('d')")
        assert_equal(parser.testParse("b == 'd'"), {:type=>"bool", :value=>true})


        parser.testParse("int c = 0")
        assert_equal(parser.testParse("c == 0"), {:type=>"bool", :value=>true})

        parser.testParse("
        int heltal(int a, int b) {

            c = a % b;
        } 
        ")
        parser.testParse("heltal(5, 3)")
        assert_equal(parser.testParse("c == 2"), {:type=>"bool", :value=>true})

    end
end
    
class Loops < Test::Unit::TestCase 

    def testForLoop 
        parser = DnD.new
        parser.log false
        
        parser.testParse("int a = 0")

        parser.testParse("
        for (int i = 0; i = i + 1; i < 10) {
            a = a + 1;
        }")

        assert_equal(parser.testParse("a"), {:type=>"int", :value=>10})
    end

    def testWhileLoop
        parser = DnD.new
        parser.log false
        
        parser.testParse("int a = 0")

        parser.testParse("
        while (a < 10) {
            a = a + 1;
        }")

        assert_equal(parser.testParse("a"), {:type=>"int", :value=>10})
    end

end

class List < Test::Unit::TestCase 
    def testLists
        parser = DnD.new
        parser.log false

        parser.testParse("int[] test = [1, 2]")

        assert_equal(parser.testParse("test"), 
        {:type=>"int", :list=>[{:value=>1, :type=>"int"}, {:value=>2, :type=>"int"}]})

        parser.testParse("int[] one = [1]")
        parser.testParse("int[] two = [2]")
        parser.testParse("int[] com = [one, two]")
        assert_equal(parser.testParse("com"), 
        {:type=>"int", :list=>[{:type=>"int", :list=>[{:value=>1, :type=>"int"}]}, {:type=>"int", :list=>[{:value=>2, :type=>"int"}]}]})
    end

end

class Recursion < Test::Unit::TestCase
    def testFuncRecursion
        parser = DnD.new
        parser.log true

        parser.testParse("int res = 1")
        parser.testParse("
        int fac(int val) {
            if(val > 0) {
                res = res * val;
                fac(val - 1);
            };
        }")

        parser.testParse("fac(3)")
        assert_equal(parser.testParse("res == 6"), {:type=>"bool", :value=>true})
    end
end