require 'set'
require 'pry'
require 'pry-nav'

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

def tail_positions(file_name, knots = 2)
    lines = read_file(file_name)
    moves = lines.map {|line| 
        direction, amount = line.split(' ')
        {:direction => direction.to_sym, :steps => amount.to_i}
    }
    # puts moves
    # binding.pry
    rope = (1..knots).map do
        {:x => 0, :y =>0}
    end

    motion = {
        :R => {:axis => :x, :direction => 1},
        :L => {:axis => :x, :direction => -1},
        :U => {:axis => :y, :direction => 1},
        :D => {:axis => :y, :direction => -1},
    }

    visited = Set.new
    moves.each do |move|
        move_along = motion[move[:direction]]
        (1..move[:steps]).each do |step|
            rope.each_with_index do |knot, index|
                previous = rope[index - 1]
                if index == 0
                    # move head
                    knot[move_along[:axis]] += move_along[:direction]
                elsif !should_move?(previous, knot)
                    # no op
                elsif previous[:y] == knot[:y]
                    diff = previous[:x] - knot[:x]
                    knot[:x] += diff > 0 ? 1 : -1 
                elsif previous[:x] == knot[:x]
                    diff = previous[:y] - knot[:y]
                    knot[:y] += diff > 0 ? 1 : -1
                else
                    knot[:x] += previous[:x] > knot[:x] ? 1 : -1
                    knot[:y] += previous[:y] > knot[:y] ? 1 : -1
                end
            end
            visited.add(rope.last.clone)
        end
    end
    visited.length
end

test_equals(tail_positions('input9-example.txt'), 13)
puts "part 1 #{tail_positions('input9.txt')}"

test_equals(tail_positions('input9-example.txt', 10), 1)
test_equals(tail_positions('input9-example-2.txt', 10), 36)
puts "part 2 #{tail_positions('input9.txt', 10)}"
