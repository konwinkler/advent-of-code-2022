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

class Beacon
    attr_accessor :position
    attr_accessor :closest_signal
    attr_accessor :distance
    def initialize(position, closest_signal)
        @position = position
        @closest_signal = closest_signal
        temp = closest_signal - position
        @distance = temp[0].abs + temp[1].abs
    end


end

def no_beacon(file_name, target_row)
    lines = read_file(file_name)
    beacons = lines.map {|line|
        scan = line.scan(/-?\d+/).map {|x| x.to_f}
        Beacon.new(Vector[scan[0], scan[1]], Vector[scan[2], scan[3]])
    }
    # find boundaries
    any_pos = beacons[0].position
    left   = (beacons.reduce(any_pos[0]) {|agg, b| [agg, b.position[0] - b.distance].min}).to_i
    right  = (beacons.reduce(any_pos[0]) {|agg, b| [agg, b.position[0] + b.distance].max}).to_i
    top    = (beacons.reduce(any_pos[1]) {|agg, b| [agg, b.position[1] - b.distance].min}).to_i
    bottom = (beacons.reduce(any_pos[1]) {|agg, b| [agg, b.position[1] + b.distance].max}).to_i
    puts "covering #{bottom - top}, #{right - left}"

    blocked = []
    # (top..bottom).each {|y|
    y = target_row
        (left..right).each_with_index {|x, index|
            current = Vector[x.to_f, y.to_f]
            beacons.each {|beacon|
                if current == beacon.position || current == beacon.closest_signal
                    break
                end
                temp = current - beacon.position
                distance = temp[0].abs + temp[1].abs
                if distance <= beacon.distance
                    blocked.push current
                    break
                end
            }
            puts index if index % 100000 == 0
        }
    # }
    on_line = blocked.select {|b| b[1] == target_row }
    # binding.pry
    on_line.size
end

test_equals(no_beacon('input15-example.txt', 10), 26)
puts "part 1 #{no_beacon('input15.txt', 2000000)}"
# 5824496 was too low