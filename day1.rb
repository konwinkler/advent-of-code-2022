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
        else
            value = x.to_i
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
    File.read(fileName).split("\n")
end

lines = readFile('input-day1.txt')
puts maxCalories(parse(lines))

def topThree(hash) 
    sorted = hash.values.sort
    sorted.last(3).sum
end


raise "top 3" unless topThree(parse(testInput)) == 45000
puts topThree(parse(lines))