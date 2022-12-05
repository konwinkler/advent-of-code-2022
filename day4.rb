require 'set'

def read_file(fileName)
    lines = File.read(fileName).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def full_overlap?(left, right)
    right_has_all_of_left = left.to_a - right.to_a
    left_has_all_of_right = right.to_a - left.to_a
    return right_has_all_of_left.empty? || left_has_all_of_right.empty?
end

test_equals(full_overlap?(1..1, 2..2), false)
test_equals(full_overlap?(1..2, 2..2), true)
test_equals(full_overlap?(1..2, 2..3), false)
test_equals(full_overlap?(2..2, 2..3), true)

def to_range(input) 
    x, y = input.split("-")
    x.to_i..y.to_i
end
test_equals(to_range('1-2'), 1..2)

def overlapping_pairs(fileName)
    lines = read_file(fileName)
    ranges = lines.map {|x|
        first, second = x.split(",")
        [to_range(first), to_range(second)]
    }
    overlaps = ranges.map {|x|
        left, right = x
        full_overlap?(left, right)
    }
    overlaps.select {|x| x}.length
end

test_equals(overlapping_pairs('input4-example.txt'), 2)
puts "part 1 #{overlapping_pairs('input4.txt')}"