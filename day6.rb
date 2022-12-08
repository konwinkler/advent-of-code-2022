require 'set'
require 'pry'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def all_different(input)
    input.uniq.length == input.length
end
test_equals(all_different(['a', 'b', 'c', 'd']), true)
test_equals(all_different(['a', 'b', 'c', 'a']), false)

def characters_before_start(input, marker_length = 4)
    buffer = []
    counter = 0
    input.split('').each do |character|
        counter += 1
        if buffer.length < marker_length
            buffer.push character
        else
            buffer.shift
            buffer.push character
            if all_different(buffer)
                return counter
            end
        end
    end
    counter
end

test_equals(characters_before_start('mjqjpqmgbljsphdztnvjfqwrcgsmlb'), 7)
test_equals(characters_before_start('bvwbjplbgvbhsrlpgdmjqwftvncz'), 5)
test_equals(characters_before_start('nppdvjthqldpwncqszvftbrmjlhg'), 6)
test_equals(characters_before_start('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg'), 10)
test_equals(characters_before_start('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'), 11)
puts "part 1 #{characters_before_start(read_file('input6.txt')[0])}"

test_equals(characters_before_start('mjqjpqmgbljsphdztnvjfqwrcgsmlb', 14), 19)
test_equals(characters_before_start('bvwbjplbgvbhsrlpgdmjqwftvncz', 14), 23)
test_equals(characters_before_start('nppdvjthqldpwncqszvftbrmjlhg', 14), 23)
test_equals(characters_before_start('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 14), 29)
test_equals(characters_before_start('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 14), 26)
puts "part 2 #{characters_before_start(read_file('input6.txt')[0], 14)}"
