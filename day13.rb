require 'set'
require 'pry'
require 'pry-nav'
require 'json'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def compare(left, right)
    if left.class == Integer && right.class == Integer
        case left <=> right
        when -1
            return :right
        when 0
            return :undecided
        when 1
            return :wrong 
        end
    elsif left.class == Array && right.class == Array
        if left.length == 0 && right.length == 0
            return :undecided
        elsif left.length == 0
            return :right
        elsif right.length == 0
            return :wrong
        else
            compare_first = compare(left[0], right[0])
            if compare_first != :undecided
                return compare_first
            else
                return compare(left.drop(1), right.drop(1))
            end
        end
    elsif left.class == Integer
        return compare([left], right)
    elsif right.class == Integer
        return compare(left, [right])
    else
        raise "unexpected parameter types #{left.class} #{right.class}"
    end
end
test_equals(compare(1, 1), :undecided)
test_equals(compare(1, 2), :right)
test_equals(compare(2, 1), :wrong)
test_equals(compare([], []), :undecided)
test_equals(compare([], [1]), :right)
test_equals(compare([1], []), :wrong)
test_equals(compare([1], [2]), :right)

def sum_indices(file_name)
    raw_pairs = File.read(file_name).split("\n\n")
    pairs = raw_pairs.map {|raw_pair|
        left, right = raw_pair.split("\n")
        {
            :left => JSON.parse(left),
            :right => JSON.parse(right)
        }
    }

    results = pairs.map {|pair|
        compare(pair[:left], pair[:right])
    }
    points = results.each_with_index.map {|result, index| result == :right ? index + 1 : 0}
    points.reduce(:+)
end

test_equals(sum_indices('input13-example.txt'), 13)
puts "part 1 #{sum_indices('input13.txt')}"