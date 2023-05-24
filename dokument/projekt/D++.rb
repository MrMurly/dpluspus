require "./grammar"
parser = DnD.new
parser.log false

ARGV.each do |a|
    Dir[a].each { |f| 
        puts f
        file = File.open(f).read
        Dir["./std/*.dpp"].each { |f2|
            file = File.open(f2).read + file   
        }
        parser.testParse(file)
    }
end
