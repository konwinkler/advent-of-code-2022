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
    (taken_path.reduce(0) {|sum, v| sum + v.rate}) * minutes
end

# BFS seach
$cache = {}
def distance(from, target)
    key = from.label + target.label
    if $cache.include? key
        return $cache[key]
    end
    distance_travelled = 0
    visited = Set.new
    to_visit = [from]
    while to_visit != []
        if to_visit.include? target
            $cache[key] = distance_travelled
            return distance_travelled
        end
        tunnels_to = (to_visit.map {|x| x.tunnels_to}).flatten
        visited.add to_visit
        to_visit = []
        distance_travelled += 1
        tunnels_to.each {|x|
            if !visited.include?(x)
                to_visit.push x
            end
        }
    end
    raise "could not find distance form #{from} to #{to}"
end

def find_pressure(valves, taken_path, path_elements, minutes_left, pressure_released)
    # binding.pry if taken_path.map {|x| x.label} == ["OS", "QJ", "QE", "OQ"]
    if minutes_left == 0
        return {:pressure => pressure_released, :path => taken_path}
    end
    if path_elements.empty?
        pressure_increase = pressure_from_valves(taken_path, minutes_left)
        return {:pressure => pressure_released + pressure_increase, :path => taken_path}
    end
    results = path_elements.each_with_index.map do |target, index|
        last_pos = taken_path.size > 0 ? taken_path.last : valves.find {|x| x.label == "AA"}
        # binding.pry
        time_needed = distance(last_pos, target) + 1 # plus 1 for time to turn on
        if time_needed > minutes_left
            next
        end
        pressure_increase = pressure_from_valves(taken_path, time_needed)
        new_taken_path = taken_path.clone
        new_taken_path.push target
        new_path_choices = path_elements - [target]

        result = find_pressure(valves, new_taken_path, new_path_choices, minutes_left - time_needed, pressure_released + pressure_increase)
        # binding.pry
        result
    end
    # binding.pry if taken_path == []
    results = results.select {|x| x != nil}
    if results == []
        return {:pressure => pressure_released + pressure_from_valves(taken_path, minutes_left), :path => taken_path}
    else
        # binding.pry
        max = results.reduce({:pressure => 0}) {|agg, result| result[:pressure] > agg[:pressure] ? result : agg}
        return max
        # return {:pressure => results.map {|x| x[:pressure]}.max, :path => taken_path}
    end
end

def most_pressure(file_name, minutes_left)
    $cache.clear
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
    valves.sort! {|a, b| b.rate <=> a.rate}

    # assumptions all tunnels are bidirectional
    # path is the order of the valves with flow rates > 0
    path_elements = valves.select{|x| x.rate > 0}
    # need recursion
    solution = find_pressure(valves, [], path_elements, minutes_left, 0)
    puts "path #{solution[:path].map {|x| x.label}}"
    puts "rates #{solution[:path].map {|x| x.rate}}"
    prev = valves.find {|x| x.label == "AA"}
    puts "distances #{solution[:path].map {|x| 
        d = distance(prev, x)
        prev = x
        d
    }}"
    # binding.pry
    solution[:pressure]

    # binding.pry
end

test_equals(most_pressure('input16-example.txt', 30), 1651)
puts "part 1 #{most_pressure('input16.txt', 30)}"
# wrong 1506 is too low