def read_file(fileName)
    File.read(fileName).split("\n")
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
test_equals(priority("z"), 26)
test_equals(priority("A"), 27)
test_equals(priority("Z"), 52)

