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

def points1(lines)
    lines.map { |line|
        points = 0
        other, myChoice = line.split
        points += $pointsForChoice[myChoice]
        points += pointsForGame(myChoice, other)

        points
    }.sum
end

raise "example error" unless points1(readFile('input-day2-example.txt')) == 15
puts "part 1", points1(readFile('input-day2.txt'))

def whichMoveForOutcome(other, outcome)
    case outcome
    when "Y" # draw
        return other
    when "X" # lose
        case other
        when "A"
            return "C"
        when "B"
            return "A"
        else
            return "B"
        end
    else
        case other
        when "A"
            return "B"
        when "B"
            return "C"
        else
            return "A"
        end
    end
end

def pointsForGame2(me, other)
    # puts me, other
    if (me == "A" && other == "C") || (me == "B" && other == "A") || (me == "C" && other == "B")
        return 6
    elsif (me == other)
        return 3
    end
    0
end

$pointsForChoice2 = {
    "A" => 1,
    "B" => 2,
    "C" => 3
}

def points2(lines)
    lines.map { |line|
        points = 0
        other, outcome = line.split
        myChoice = whichMoveForOutcome(other, outcome)
        points += $pointsForChoice2[myChoice]
        points += pointsForGame2(myChoice, other)

        points
    }.sum
end

raise "part 2" unless points2(readFile('input-day2-example.txt')) == 12
puts "part 2", points2(readFile('input-day2.txt'))
