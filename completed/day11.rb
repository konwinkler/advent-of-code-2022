require 'set'
require 'pry'
require 'pry-nav'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

$item_counter = 0

class Item
    attr_accessor :id
    attr_accessor :worry_level
    attr_accessor :max_worry_level
    attr_accessor :divide_worry

    def initialize(worry_level, divide_worry)
        @id = $item_counter
        @worry_level = worry_level
        $item_counter += 1
        @divide_worry = divide_worry
    end

    def adjust_worry(worry_operation)
        @worry_level = worry_operation.(@worry_level)
        @worry_level = @worry_level / 3 if @divide_worry
        @worry_level = @worry_level % @max_worry_level
    end

    def test_worry(decision_test)
        decision_test.(@worry_level)
    end
end

class Monkey
    attr_accessor :id
    attr_accessor :items
    attr_accessor :inspection_count
    attr_accessor :worry_operation
    attr_accessor :decision_test
    attr_accessor :throw_directions
    attr_accessor :divisible_by

    def initialize(id, items, worry_operation, decision_test, throw_directions, divisible_by)
        @id = id
        @items = items
        @inspection_count = 0
        @worry_operation = worry_operation
        @decision_test = decision_test
        @throw_directions = throw_directions
        @divisible_by = divisible_by
    end

    def inspect_item
        @inspection_count += 1
    end
end

def parse(lines, divide_worry)
    monkeys = []
    slices = lines.each_slice(7)
    slices.each_with_index do |slice, current_monkey|
        items = []
        divisible_by = 0
        worry_operation = nil
        decision_test = nil
        throw_direction = {}
        slice.each_with_index do |line, monkey_part|
            case monkey_part
            when 1
                parts = line.split ' '
                parts = parts.drop(2)
                items = parts.map {|value| Item.new(value.to_i, divide_worry)}
            when 2
                parts = line.split ' '
                amount = parts.pop
                op = parts.pop
                if op == '+'
                    if (amount == 'old')
                        worry_operation = lambda {|old_worry| old_worry + old_worry}
                    else
                        worry_operation = lambda {|old_worry| old_worry + amount.to_i}
                    end
                elsif op == '*'
                    if (amount == 'old')
                        worry_operation = lambda {|old_worry| old_worry * old_worry}
                    else
                        worry_operation = lambda {|old_worry| old_worry * amount.to_i}
                    end
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
            end         
        end    
        monkey = Monkey.new(current_monkey, items, worry_operation, decision_test, throw_direction, divisible_by)
        monkeys.push monkey
    end
    monkeys
end

def level_moneky_business(file_name, rounds = 20, divide_worry = true)
    lines = read_file(file_name)
    monkeys = parse(lines, divide_worry)

    # find the max worry level
    max_worry = monkeys.map {|m| m.divisible_by}.reduce(:*)
    monkeys.each do |m|
        m.items.each do |i|
            i.max_worry_level = max_worry
        end
    end

    # 20 rounds
    (1..rounds).each do |round|
        monkeys.each_with_index do |monkey|
            monkey.items.each do |item|
                item.adjust_worry(monkey.worry_operation)
                monkey.inspect_item
                target = monkey.throw_directions[item.test_worry(monkey.decision_test)]
                monkeys[target].items.push item
                # puts "monkey #{monkey.id} throws #{item.worry_level} to #{target}"
            end
            monkey.items = []
        end
        if false
            puts "After round #{round}"
            monkeys.each do |monkey|
                puts "Monkey #{monkey.id}: items #{monkey.items.map {|i| i.worry_level}}"
            end
        end
        if false && (round % 1000 == 0 || round == 1 || round == 20)
            puts "round #{round}"
            monkeys.each do |monkey|
                puts "Monkey #{monkey.id} inspected #{monkey.inspection_count} items"
            end
        end
    end
    inspection_counts = monkeys.map {|monkey| monkey.inspection_count}
    inspection_counts.sort.last(2).reduce(:*)
end
test_equals(level_moneky_business('input11-example.txt'), 10605)
puts "part 1 #{level_moneky_business('input11.txt')}"

test_equals(level_moneky_business('input11-example.txt', 10000, false), 2713310158)
puts "part 2 #{level_moneky_business('input11.txt', 10000, false)}"
