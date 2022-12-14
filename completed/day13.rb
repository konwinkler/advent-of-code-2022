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
        return left <=> right
    elsif left.class == Array && right.class == Array
        if left.length == 0 && right.length == 0
            return 0
        elsif left.length == 0
            return -1
        elsif right.length == 0
            return 1
        else
            compare_first = compare(left[0], right[0])
            if compare_first != 0
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
test_equals(compare(1, 1), 0)
test_equals(compare(1, 2), -1)
test_equals(compare(2, 1), 1)
test_equals(compare([], []), 0)
test_equals(compare([], [1]), -1)
test_equals(compare([1], []), 1)
test_equals(compare([1], [2]), -1)

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
    points = results.each_with_index.map {|result, index| result == -1 ? index + 1 : 0}
    points.reduce(:+)
end

test_equals(sum_indices('input13-example.txt'), 13)
puts "part 1 #{sum_indices('input13.txt')}"

def decoder_key(file_name, packet_one, packet_two)
    lines = read_file(file_name).filter {|x| x != ''}
    packets = lines.map {|line| JSON.parse(line)}
    packets.push(packet_one)
    packets.push(packet_two)
    packets.sort! {|left, right| compare(left, right)}
    points = packets.each_with_index.map {|packet, index| (packet == packet_one || packet == packet_two) ? index + 1 : 0}
    points.filter {|x| x != 0}.reduce(:*)
end

test_equals(decoder_key('input13-example.txt', [[2]], [[6]]), 140)
puts "part 2 #{decoder_key('input13.txt', [[2]], [[6]])}"