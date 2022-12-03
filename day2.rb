def readFile(fileName)
    File.read(fileName).split("\n")
end

$pointsForChoice = {
    "X" => 1,
    "Y" => 2,
    "Z" => 3
}

def pointsForGame(me, other)
    # puts me, other
    if (me == "X" && other == "C") || (me == "Y" && other == "A") || (me == "Z" && other == "B")
        return 6
    elsif (me == "X" && other == "A") || (me == "Y" && other == "B") || (me == "Z" && other == "C")
        return 3
    end
    0
end

def points(lines)
    lines.map { |line|
        points = 0
        other, myChoice = line.split
        points += $pointsForChoice[myChoice]
        points += pointsForGame(myChoice, other)

        points
    }.sum
end

raise "example error" unless points(readFile('input-day2-example.txt')) == 15
puts "part 1", points(readFile('input-day2.txt'))