require 'set'
require 'pry'
require 'pry-nav'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

class Instruction
    attr_accessor :amount
    attr_accessor :cycles_needed
    attr_accessor :current_cycle

    def initialize(cycles_needed, amount)
        @cycles_needed = cycles_needed
        @amount = amount
        @current_cycle = 0
    end
end



def sum_signals(file_name)
    instructions = []
    lines = read_file(file_name)
    lines.map {|line|
        operator, amount = line.split ' '
        if operator == 'noop'
            instruction = Instruction.new(1, 0)
        else
            instruction = Instruction.new(2, amount.to_i)
        end
        instructions.push instruction
    }

    cycle = 0
    x = 1
    instruction = nil
    sum = 0
    while !instructions.empty?
        cycle += 1
        if instruction == nil
            instruction = instructions.shift
        end
        # during the cycle before x got adjusted
        if (cycle - 20) % 40 == 0
            sum += cycle * x
        end
        instruction.current_cycle += 1 
        if instruction.current_cycle == instruction.cycles_needed
            x += instruction.amount
            instruction = nil
        end
    end
    sum
end

test_equals(sum_signals('input10-example.txt'), 13140)
puts "part 1 #{sum_signals('input10.txt')}"
