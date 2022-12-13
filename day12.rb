require 'set'
require 'pry'
require 'pry-nav'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

class Node
    attr_accessor :x
    attr_accessor :y
    attr_accessor :height
    attr_accessor :steps

    def initialize(x, y)
        @x = x
        @y = y
    end

    def at_most_one_higher(other)
        other.height.ord - @height.ord <= 1
    end

    def find_neighbors(nodes, height, width)
        neighbors = []
        [@y - 1, @y + 1].each do |y|
            if y < 0 || y >= height
                next
            end
            neighbor = nodes.find {|n| n.x == @x && n.y == y}                
            neighbors.push neighbor if at_most_one_higher(neighbor)
        end
        [@x - 1, @x + 1].each do |x|
            if x < 0 || x >= width
                next
            end
            neighbor = nodes.find {|n| n.x == x && n.y == @y}                
            neighbors.push neighbor if at_most_one_higher(neighbor)
        end
        neighbors
    end

    def eql?(other)
        @x == other.x && @y == other.y
    end

    def ==(other)
        eql?(other)
    end

    def hash
        @x.to_i + 100 + @y.to_i
    end
end

def shortest_path(file_name)
    start = nil
    finish = nil
    lines = read_file(file_name)
    nodes = []
    height = lines.length
    width = lines[0].split('').length
    lines.each_with_index do |line, y|
        line.split('').each_with_index do |height, x|
            node = Node.new(x, y)
            case height
            when 'S'
                node.height = 'a'
                start = node
                start.steps = 0
            when 'E'
                node.height = 'z'
                finish = node
            else
                node.height = height
            end
            nodes.push node
        end
    end

    to_visit = [start]
    visited = Set.new
    found_finish = false
    while !found_finish
        current = to_visit.shift
        if current == finish
            return current.steps
        end
        steps = current.steps + 1
        neighbors = current.find_neighbors(nodes, height, width)
        neighbors.each do |neighbor|
            if visited.include?(neighbor) || to_visit.include?(neighbor)
                next
            end
            neighbor.steps = steps
            to_visit.push neighbor
        end
        visited.add current
    end
    raise "could not find path"
end

test_equals(shortest_path('input12-example.txt'), 31)
puts "part 1 #{shortest_path('input12.txt')}"