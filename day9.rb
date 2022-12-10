require 'set'
require 'pry'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def should_move?(head, tail)
    distance_x = (head[:x] - tail[:x]).abs
    distance_y = (head[:y] - tail[:y]).abs
    return distance_x > 1 || distance_y > 1
end
test_equals(should_move?({:x=>1,:y=>0},{:x=>0,:y=>0}), false)
test_equals(should_move?({:x=>2,:y=>0},{:x=>0,:y=>0}), true)
test_equals(should_move?({:x=>0,:y=>-1},{:x=>0,:y=>0}), false)
test_equals(should_move?({:x=>0,:y=>-2},{:x=>0,:y=>0}), true)
test_equals(should_move?({:x=>1,:y=>1},{:x=>0,:y=>0}), false)

def tail_positions(file_name)
    lines = read_file(file_name)
    moves = lines.map {|line| 
        direction, amount = line.split(' ')
        {:direction => direction.to_sym, :steps => amount.to_i}
    }
    # puts moves

    head = {:x => 0, :y =>0}
    tail = {:x => 0, :y =>0}

    motion = {
        :R => {:axis => :x, :direction => 1},
        :L => {:axis => :x, :direction => -1},
        :U => {:axis => :y, :direction => 1},
        :D => {:axis => :y, :direction => -1},
    }

    visited = Set.new
    moves.each do |move|
        # puts move
        move_along = motion[move[:direction]]
        (1..move[:steps]).each do |step|
            head[move_along[:axis]] += move_along[:direction]
            if !should_move?(head, tail)
                # no op
            elsif head[:y] == tail[:y]
                diff = head[:x] - tail[:x]
                tail[:x] += diff > 0 ? 1 : -1 
            elsif head[:x] == tail[:x]
                diff = head[:y] - tail[:y]
                tail[:y] += diff > 0 ? 1 : -1
            else
                tail[:x] += head[:x] > tail[:x] ? 1 : -1
                tail[:y] += head[:y] > tail[:y] ? 1 : -1
            end
            visited.add(tail.clone)
            # puts "head #{head} tail #{tail}"
            # puts visited
        end
    end
    visited.length
end

test_equals(tail_positions('input9-example.txt'), 13)
puts "part 1 #{tail_positions('input9.txt')}"