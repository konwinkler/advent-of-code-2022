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
hash = parse(testInput)

def maxCalories(input)
    maxCalories = -1
    input.each {|key, value|
        maxCalories = [maxCalories, value].max
    }
    maxCalories
end
raise "example failure" unless maxCalories(hash) == 24000
