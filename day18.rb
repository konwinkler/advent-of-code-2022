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

$sides = [
    Vector[1, 0, 0],
    Vector[-1, 0, 0],
    Vector[0, 1, 0],
    Vector[0, -1, 0],
    Vector[0, 0, 1],
    Vector[0, 0, -1],
]

def surface_area(file_name)
    lines = read_file(file_name)
    cubes = Set.new(lines.map {|line|
        parts = line.split(',').map(&:to_i)
        Vector[*parts]
    })
    surface_area = 0
    cubes.each do |cube|
        $sides.each do |side|
            to_check = cube + side
            surface_area += 1 if !cubes.include? to_check
        end
    end

    surface_area
end

test_equals(surface_area('input18-example.txt'), 64)
puts "part 1 #{surface_area('input18.txt')}"