testInput = [
    "1000",
    "2000",
    "3000",
    "",
    "4000",
    "",
    "5000",
    "6000",
    "",
    "7000",
    "8000",
    "9000",
    "",
    "10000"
]

def parse(input)
    hash = {}
    counter = 0
    input.each { |x|
        if x == ""
            counter += 1
        elsif x == "\n"
            counter += 1
        else
            value = Integer(x)
            if hash.has_key?(counter)
                hash[counter] = hash[counter] + value
            else
                hash[counter] = value
            end
        end
    }
    hash
end

def maxCalories(input)
    maxCalories = -1
    input.each {|key, value|
        maxCalories = [maxCalories, value].max
    }
    maxCalories
end

raise "example failure" unless maxCalories(parse(testInput)) == 24000

def readFile(fileName)
    lines = []
    File.readlines(fileName).each do |line|
        lines.push line
    end
    lines
end
partOne =  readFile('input-day1.txt')
# puts partOne
puts maxCalories(parse(partOne))

def topThree(hash) 
    sorted = hash.values.sort
    sorted.last(3).sum
end


raise "top 3" unless topThree(parse(testInput)) == 45000
puts topThree(parse(partOne))