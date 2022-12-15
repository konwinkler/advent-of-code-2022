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

def resting_sand(file_name)
    raw_lines = read_file(file_name)
    raw_paths = raw_lines.map {|line| line.split(' -> ')}
    lines = raw_paths.map {|p| p.map {|x|
            x, y = x.split(',')
            Vector[x.to_f, y.to_f]
        }
    }

    # find boundaries
    highest_y = lines.reduce(0) {|high, l|
        l_y = l.reduce(0) {|agg, point| [agg, point[1]].max}
        [high, l_y].max
    }

    # create a hash of blocked tiles
    blocked_tiles = Set.new
    lines.each {|line|
        line.first(line.size - 1).each_with_index {|point, index|
            next_point = line[index + 1]
            direction = (next_point - point).normalize
            current = point.clone
            while current != next_point
                blocked_tiles.add current
                current += direction
            end
            blocked_tiles.add next_point
        }
    }

    sand_tiles = Set.new
    directions = [
        Vector[0, 1], # down
        Vector[-1, 1], # down left
        Vector[1, 1], # down right
    ]

    sand = Vector[500.0, 0.0]
    while true
        # binding.pry if sand_tiles.size == 24
        sand_moved = false
        directions.each {|dir|
            new_pos = sand + dir
            if !blocked_tiles.include?(new_pos) && !sand_tiles.include?(new_pos)
                sand = new_pos
                sand_moved = true
                break
            end
        }
        if !sand_moved
            sand_tiles.add(sand)
            sand = Vector[500.0, 0.0]
        end
        # if higher than boundary stop
        if sand[1] > highest_y
            draw(blocked_tiles, sand_tiles, highest_y)
            return sand_tiles.size
        end
    end
end

def draw(blocked_tiles, sand_tiles, highest_y)
    left = (blocked_tiles.reduce(500.0) {|agg, tile| [agg, tile[0]].min} - 1).to_i
    right = (blocked_tiles.reduce(500.0) {|agg, tile| [agg, tile[0]].max} + 1).to_i
    rows = []
    (0..highest_y).each {|y|
        row = ''
        (left..right).each {|x|
            current = Vector[x.to_f, y.to_f]
            if blocked_tiles.include?(current)
                row += '#'
            elsif sand_tiles.include?(current)
                row += 'o'
            elsif current == Vector[500.0, 0.0]
                row += '+'
            else
                row += ' '
            end
        }
        rows.push row
    }
    puts rows 
end

test_equals(resting_sand('input14-example.txt'), 24)
puts "part 1 #{resting_sand('input14.txt')}"