require 'set'
require 'pry'
require 'pry-nav'
require 'json'
require 'matrix'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

# y == 0 is at the bottom

Chamber = Struct.new(:tiles) do
    def height
        tiles.reduce(0) {|h, c| [h, c.y]}
    end
end
$gust_map = {
    '<' => Vector[-1, 0],    
    '>' => Vector[1, 0]
}
class Rock
    attr_accessor :tiles
    def initialize(tiles)
        @tiles = tiles
    end
    def push(gust, chamber)
        push_direction = $gust_map[gust]
        new_tiles = @tiles.map {|x| x + push_direction}
        # out of bounds?
        return itself if new_tiles.select {|x| x[0] < 0 || x[0] > 6}.any?
        # running into an existing tile?
        return itself if new_tiles.select {|x| chamber.tiles.include? x }.any?
        # updates tiles
        @tiles = new_tiles
        itself
    end
    def fall(chamber)
        fall_direction = Vector[0, -1]
        new_tiles = @tiles.map {|x| x + fall_direction}
        blocked = false
        # hit bottom?
        blocked = true if new_tiles.select {|x| x[y] == 0}.any?
        # hit other tile?
        blocked = true if new_tiles.select {|x| chamber.tiles.include? x}.any?
        blocked
end
test_rock = Rock.new([Vector[0, 1]])
test_chamber = Chamber.new([])
test_equals(test_rock.push('>', test_chamber).tiles, [Vector[1, 1]])
test_equals(test_rock.push('<', test_chamber).tiles, [Vector[0, 1]])
test_equals(test_rock.push('<', test_chamber).tiles, [Vector[0, 1]])

test_equals(test_rock.fall(test_chamber), true)
test_equals(test_rock.fall(test_chamber), false)
test_equals(test_rock.tiles, [Vector[0, 0]]])

class Jet
    @counter
    def initialize(jet_pattern)
        @jet_pattern = jet_pattern
        @counter = 0
    end
    def next
        @counter = 0 if @counter >= @jet_pattern.length
        gust = @jet_pattern[@counter]
        @counter += 1
        gust
    end
end
test_jet = Jet.new(['<', '>'])
test_equals(test_jet.next, '<')
test_equals(test_jet.next, '>')
test_equals(test_jet.next, '<')

class Ceiling
    @counter
    @rocks
    def initialize(rock_templates)
        @counter = 0
        @rocks = rock_templates.map {|r|
            r.map {|x| Vector[x[0], x[1]]}
        }
    end
    def next(start_x = 0, start_y = 0)
        @counter = 0 if @counter >= @rocks.length
        rock = @rocks[@counter]
        @counter += 1
        start_position = Vector[start_x, start_y]
        Rock.new(rock.map {|x| x + start_position})
    end
end
test_ceiling = Ceiling.new([[[1, 1]], [[2, 2], [3, 3]]])
test_equals(test_ceiling.next.tiles, [Vector[1, 1]])
test_equals(test_ceiling.next.tiles, [Vector[2, 2], Vector[3, 3]])
test_equals(test_ceiling.next(5, 5).tiles, [Vector[6, 6]])

def height_after(file_name, target_stopped_rocks)
    line = read_file(file_name)[0]
    jet = Jet.new(line.split '')

    rock_templates = [
        [[0, 0], [1, 0], [2, 0], [3, 0]]
    ]
    ceiling = Ceiling.new(rock_templates)

    chamber = Chamber.new([])
    rock = ceiling.next(2, chamber.height + 3)
    # rock affected by gust
    rock.push(jet.next, chamber)
    moved = rock.fall(chamber)
    binding.pry

end

test_equals(height_after('input17-example.txt', 2022), 3068)