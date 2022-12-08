require 'set'
require 'pry'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

module NodeType
    FILE = 1
    DIR = 2
end
class Node
    attr_accessor :name
    attr_accessor :type
    attr_accessor :children
    attr_accessor :own_size
    attr_accessor :parent
    def initialize(name, type)
        @name = name
        @type = type
        @children = []
        @own_size = 0
        @parent = nil
    end

    def full_size
        @children.reduce(0) { |sum, child| sum + child.full_size } + @own_size
    end
end

def find_nodes_at_most_100k(node)
    result = []
    node.children.each do |child|
        result.concat(find_nodes_at_most_100k(child))
    end
    result.push(node) if node.type == NodeType::DIR && node.full_size <= 100000
    result
end

def parse_nodes(lines)
    root = Node.new('/', NodeType::DIR)
    current = nil
    level = 0
    lines.each do |line|
        if line == '$ cd /'
            current = root
        elsif line == '$ ls'
            # no op
        elsif line == '$ cd ..'
            level = level - 1
            current = current.parent
        elsif line.start_with?('$ cd')
            level = level + 1
            dir_name = line.split(' ')[2]
            new_dir = Node.new(dir_name, NodeType::DIR)
            new_dir.parent = current
            current.children.push new_dir
            current = new_dir
        elsif line == '\n'
            # no op
        elsif
            if line.start_with?('dir')
                # ignore listing of dirs for now
            else
                # this is a file
                size, file_name = line.split(' ')
                new_file = Node.new(file_name, NodeType::FILE)
                new_file.own_size = size.to_i
                current.children.push(new_file)
            end
        end
    end
    root
end

def sum_directories(file_name)
    lines = read_file(file_name)
    root = parse_nodes(lines)
    
    nodes_above = find_nodes_at_most_100k root
    nodes_above.reduce(0) {|sum, node| sum + node.full_size}
end

test_equals(sum_directories('input7-example.txt'), 95437)
puts "part 1 #{sum_directories('input7.txt')}"

def find_directories_above(node, limit)
    result = []
    node.children.each do |child|
        result.concat(find_directories_above(child, limit))
    end
    result.push(node) if node.type == NodeType::DIR && node.full_size >= limit
    result
end

def size_of_dir_to_delete(file_name)
    lines = read_file file_name
    root = parse_nodes lines

    needed_space = 30000000
    file_system_space = 70000000
    taken_space = root.full_size
    unused_space = file_system_space - taken_space
    to_delete = needed_space - unused_space

    porential_dirs = find_directories_above(root, to_delete)
    dir = porential_dirs.reduce(root) {|smallest, current|
        if smallest.full_size < current.full_size
            smallest
        else
            current
        end
    }
    dir.full_size
end

test_equals(size_of_dir_to_delete('input7-example.txt'), 24933642)
puts "part 2 #{size_of_dir_to_delete('input7.txt')}"
