require 'set'
require 'pry'
require 'pry-nav'
require 'json'
require 'matrix'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

Rock = Struct.new(:id)
Rock_Tile = Struct.new(:id)
Chamber = Struct.new(:id)
Chamber_Tile = Struct.new(:id)
class Jet
    @counter
    def initialize(jet_pattern)
        @jet_pattern = jet_pattern
        @counter = 0
    end
    def next
        @counter = 0 if @counter >= @jet_pattern.length
        gust = @jet_pattern[@counter]
        @counter += 1
        gust
    end
end
test_jet = Jet.new(['<', '>'])
test_equals(test_jet.next, '<')
test_equals(test_jet.next, '>')
test_equals(test_jet.next, '<')

def height_after(file_name, target_stopped_rocks)
    line = read_file(file_name)[0]
    jet = Jet.new(line.split '')

    
end

test_equals(height_after('input17-example.txt', 2022), 3068)