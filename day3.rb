require 'set'

def read_file(fileName)
    lines = File.read(fileName).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def priority(char)
    upperChar = char.ord < 97
    if (upperChar)
        return char.ord - 38
    else
        return char.ord - 96
    end
end

test_equals(priority("a"), 1)
test_equals(priority("c"), 3)
test_equals(priority("z"), 26)
test_equals(priority("A"), 27)
test_equals(priority("Z"), 52)

def rucksack_to_duplicated_items(rucksack)
    middle = rucksack.length / 2
    # puts "value #{rucksack} class #{rucksack.class}"
    first_compartment = rucksack.split("").take(middle)
    second_compartment = rucksack.split("").last(middle)
    duplicated_items = Set[]
    first_compartment.each {|x|
        if second_compartment.include? x
            duplicated_items.add x
        end
    }
    return duplicated_items
end

def sum_priorities(file)
    read_file(file)
    .map {|x| rucksack_to_duplicated_items x}
    .map {|x| x.map {|x| priority x} }
    .flatten
    .sum
end

test_equals(sum_priorities('input3-example.txt'), 157)
puts "part 1 #{sum_priorities('input3.txt')}"

