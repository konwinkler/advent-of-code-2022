require 'set'
require 'pry'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end


def index_to_pos(index)
    index.to_i / 4
end
test_equals(index_to_pos(1), 0)
test_equals(index_to_pos(5), 1)
test_equals(index_to_pos(9), 2)

def top_crates(inputFile, single = true)
    lines = read_file(inputFile)
    stacks_count = lines[0].length / 3

    parsed_initial_stacks = 0
    initial_stacks = []
    moves = []
    lines.each do |line|
        parsed_initial_stacks += 1 if !line.split('').any? '['
        initial_stacks.push(line) if parsed_initial_stacks == 0
        moves.push(line) if parsed_initial_stacks >= 3
    end

    stacks = {}
    initial_stacks.reverse.each_with_index do |line, line_index|
        line.split('').each_with_index do |item, item_index|
            is_item = !!(item.match /[A-Z]/)
            if is_item
                pos =  index_to_pos item_index
                if stacks.has_key? pos
                    stacks[pos].push(item)
                else
                    stacks[pos] = [item]
                end
            end
        end
    end
    # puts stacks


    moves.each do |move|
        separated = move.split(' ')
        amount = separated[1].to_i
        # change to zero index 
        from = separated[3].to_i - 1
        to = separated[5].to_i - 1
        if single
            (1..amount).each do
                item = stacks[from].pop
                stacks[to].push item
            end
        else
            items = []
            (1..amount).each do
                items.push stacks[from].pop
            end
            stacks[to].push items.reverse
            stacks[to] = stacks[to].flatten
        end
    end
    # puts stacks

    top_items = stacks.values.map do |stack|
        stack.last
    end
    top_items.join
end

test_equals(top_crates('input5-example.txt'), 'CMZ')
puts "part 1 #{top_crates('input5.txt')}"

test_equals(top_crates('input5-example.txt', false), 'MCD')
puts "part 2 #{top_crates('input5.txt', false)}"



