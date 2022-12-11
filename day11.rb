require 'set'
require 'pry'
require 'pry-nav'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

class Item
    attr_accessor :id
    attr_accessor :worry_level

    def initialize(id)
        @id = id
        @worry_level = 0
    end
end

class Monkey
    attr_accessor :id
    attr_accessor :items
    attr_accessor :inspection_count
    attr_accessor :worry_operation
    attr_accessor :decision_test
    attr_accessor :throw_directions

    def initialize(id, items, worry_operation, decision_test, throw_directions)
        @id = id
        @items = items
        @inspection_count = 0
        @worry_operation = worry_operation
        @decision_test = decision_test
        @throw_directions = throw_directions
    end
end

def parse(lines)
    monkeys = []
    items = []
    divisible_by = 0
    worry_operation = nil
    decision_test = nil
    throw_direction = {}
    lines.each_with_index do |line, index|
        current_monkey = index / 7
        monkey_part = index % 7
        case monkey_part
        when 1
            parts = line.split ' '
            parts = parts.drop(2)
            items = parts.map {|value| Item.new(value.to_i)}
        when 2
            parts = line.split ' '
            amount = parts.pop.to_i
            op = parts.pop
            if op == '+'
                worry_operation = lambda {|old_worry| old_worry + amount}
            elsif op == '*'
                worry_operation = lambda {|old_worry| old_worry * amount}
            else
                raise "operation parse error, #{op}"
            end
        when 3
            divisible_by = line.split(' ').pop.to_i
            decision_test = lambda {|value| (value.to_f / divisible_by) % 1 == 0}
        when 4
            throw_to = line.split(' ').pop.to_i
            throw_direction[true] = throw_to
        when 5
            throw_to = line.split(' ').pop.to_i
            throw_direction[false] = throw_to
        when 6
            monkey = Monkey.new(current_monkey, items, worry_operation, decision_test, throw_direction)
            monkeys.push monkey
            items = []
            divisible_by = 0
            worry_operation = nil
            decision_test = nil
            throw_direction = {}
        end         
    end
    monkeys
end

def level_moneky_business(file_name)
    lines = read_file(file_name)
    monkeys = parse(lines)
    binding.pry
end
test_equals(level_moneky_business('input11-example.txt'), 10605)
