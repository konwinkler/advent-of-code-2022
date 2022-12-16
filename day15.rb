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

class Sensor
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

def no_sensor(file_name, target_row)
    lines = read_file(file_name)
    sensors = lines.map {|line|
        scan = line.scan(/-?\d+/).map {|x| x.to_f}
        Sensor.new(Vector[scan[0], scan[1]], Vector[scan[2], scan[3]])
    }
    # find boundaries
    any_pos = sensors[0].position
    left   = (sensors.reduce(any_pos[0]) {|agg, b| [agg, b.position[0] - b.distance].min}).to_i
    right  = (sensors.reduce(any_pos[0]) {|agg, b| [agg, b.position[0] + b.distance].max}).to_i
    top    = (sensors.reduce(any_pos[1]) {|agg, b| [agg, b.position[1] - b.distance].min}).to_i
    bottom = (sensors.reduce(any_pos[1]) {|agg, b| [agg, b.position[1] + b.distance].max}).to_i
    # puts "covering #{bottom - top}, #{right - left}"

    blocked = []
    # (top..bottom).each {|y|
    y = target_row
        (left..right).each_with_index {|x, index|
            current = Vector[x.to_f, y.to_f]
            sensors.each {|sensor|
                if current == sensor.position || current == sensor.closest_signal
                    break
                end
                temp = current - sensor.position
                distance = temp[0].abs + temp[1].abs
                if distance <= sensor.distance
                    blocked.push current
                    break
                end
            }
            # puts index if index % 100000 == 0
        }
    # }
    on_line = blocked.select {|b| b[1] == target_row }
    # binding.pry
    on_line.size
end

test_equals(no_sensor('input15-example.txt', 10), 26)
# puts "part 1 #{no_sensor('input15.txt', 2000000)}"

def is_blocked?(current, sensors, boundary)
    if current[0] < 0 || current[1] < 0 || current[0] > boundary || current[1] > boundary
        return true
    end
    block = false
    sensors.each {|sensor|
        if current == sensor.position || current == sensor.closest_signal
            block = true
            break
        end
        temp = current - sensor.position
        distance = temp[0].abs + temp[1].abs
        if distance <= sensor.distance
            block = true
            break
        end
    }
    block
end

def tuning_frequency(file_name, boundary)
    lines = read_file(file_name)
    sensors = lines.map {|line|
        scan = line.scan(/-?\d+/).map {|x| x.to_f}
        Sensor.new(Vector[scan[0], scan[1]], Vector[scan[2], scan[3]])
    }

    # this is taking too long, maybe instead of going through all corrds
    # go in a circle around all sensors with 1 additional distance?
    # actually it's more of a diamond shape, totally doable
    sensors.sort! {|a, b| a.distance <=> b.distance}
    sensors.each {|sensor|
        puts "looking around sensor #{sensor.position} with distance #{sensor.distance}"
        # binding.dir
        top = Vector[sensor.position[0], sensor.position[1] - sensor.distance - 1]
        bottom = Vector[sensor.position[0], sensor.position[1] + sensor.distance + 1]
        left = Vector[sensor.position[0] - sensor.distance - 1, sensor.position[1]]
        right = Vector[sensor.position[0] + sensor.distance + 1, sensor.position[1]]
        # go around
        current = top.clone
        while current != right
            current += Vector[1, 1]
            if !is_blocked?(current, sensors, boundary)
                return current[0] * 4000000 + current[1]
            end
        end
        current = right.clone
        while current != bottom
            current += Vector[-1, 1]
            if !is_blocked?(current, sensors, boundary)
                return current[0] * 4000000 + current[1]
            end
        end
        current = bottom.clone
        while current != left
            current += Vector[-1, -1]
            if !is_blocked?(current, sensors, boundary)
                return current[0] * 4000000 + current[1]
            end
        end
        current = left.clone
        while current != top
            current += Vector[1, -1]
            if !is_blocked?(current, sensors, boundary)
                return current[0] * 4000000 + current[1]
            end
        end
    }
    raise 'could not find unblocked tile'
end

test_equals(tuning_frequency('input15-example.txt', 20), 56000011)
puts "part 2 #{tuning_frequency('input15.txt', 4000000)}"
