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

Valve = Struct.new(:label, :rate, :tunnels_to_labels) do
    attr_accessor :tunnels_to
end

def pressure_from_valves(taken_path, minutes = 1)
    (path.reduce(0) {|sum, v| sum + v.rate}) * minutes
end

# BFS seach
def distance(from, to)
    current = from
    visited = []
    neighbors = current.tunnels_to
    1
end

def find_path(valves, taken_path, path_elements, minutes_left, pressure_released)
    if minutes_left == 0
        return pressure_released
    end
    if path_elements.empty?
        pressure_increase = pressure_released + pressure_from_valves(taken_path)
        return find_path(valves, taken_path, path_elements, minutes_left - 1, pressure_released + pressure_increase)
    end
    path_elements.each_with_index do |target, index|
        left_over = path_elements - [target]
        last_pos = taken_path.last
        binding.pry
        time_needed = distance(last_pos, target) + 1 # plus 1 for time to turn on
        if time_needed > minutes_left
            break
        end
        pressure_increase = pressure_from_valves(taken_path, time_needed)
    end


end

def most_pressure(file_name, minutes_left)
    lines = read_file(file_name)
    valves = lines.map {|line|
        rate = line.scan(/\d+/)[0].to_i
        identifiers = line.scan(/[A-Z][A-Z]/)
        label = identifiers.shift
        tunnels_to_labels = identifiers
        Valve.new(label, rate, tunnels_to_labels)
    }
    valves.each do |valve|
        valve.tunnels_to = valves.select {|v| valve.tunnels_to_labels.include?(v.label)}
    end

    # assumptions all tunnels are bidirectional
    # path is the order of the valves with flow rates > 0
    path_elements = valves.select{|x| x.rate > 0}
    # need recursion
    solution = find_path(valves, [], path_elements, minutes_left, 0)


    binding.pry
end

test_equals(most_pressure('input16-example.txt', 30), 1651)