def read_file(fileName)
    File.read(fileName).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def value(char)
    upperChar = char.ord < 97
    if (upperChar)
        return char.ord - 38
    else
        return char.ord - 96
    end
end

# test char to point value conversion
test_equals(value("a"), 1)
test_equals(value("z"), 26)
test_equals(value("A"), 27)
test_equals(value("Z"), 52)

