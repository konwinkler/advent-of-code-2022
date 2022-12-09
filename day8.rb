require 'set'
require 'pry'

def read_file(file_name)
    lines = File.read(file_name).split("\n")
end

def test_equals(actual, expected)
    raise "test failed, actual: #{actual} expected: #{expected}" unless actual == expected
end

def is_visible?(x, y, map)
    width = map[0].length - 1
    height = map.length - 1
    if x == 0 || y == 0 || x == width || y == height
        return true
    end
    tree = map[y][x]
    max_left = (0..x-1).reduce(0) {|max, i| [max, map[y][i]].max}
    if max_left < tree
        return true
    end
    max_right = (x+1..width).reduce(0) {|max, i| [max, map[y][i]].max}
    if max_right < tree
        return true
    end
    max_top = (0..y-1).reduce(0) {|max, i| [max, map[i][x]].max}
    if max_top < tree
        return true
    end
    max_bottom = (y+1..height).reduce(0) {|max, i| [max, map[i][x]].max}
    if max_bottom < tree
        return true
    end
    false
end
test_equals(is_visible?(0, 0, [[0]]), true)
test_equals(is_visible?(1, 1, [[1,1,1],[1,0,1],[1,1,1]]), false)
test_equals(is_visible?(1, 1, [[2,2,2],[1,2,2],[2,2,2]]), true)
test_equals(is_visible?(1, 1, [[2,2,2],[2,2,1],[2,2,2]]), true)
test_equals(is_visible?(1, 1, [[2,1,2],[2,2,2],[2,2,2]]), true)
test_equals(is_visible?(1, 1, [[2,2,2],[2,2,2],[2,1,2]]), true)

def visible_trees(file_name)
    lines = read_file(file_name)
    map = lines.map {|line| line.split('').map {|x| x.to_i}}
    count_visible = 0
    map.each_with_index {|row, y|
        row.each_with_index{|tree, x|
            if is_visible?(x, y, map)
                count_visible += 1
            end
        }
    }
    count_visible
end

test_equals(visible_trees('input8-example.txt'), 21)
puts "part 1 #{visible_trees('input8.txt')}"

def scenic_score(x, y, map)
    width = map[0].length - 1
    height = map.length - 1
    if x == 0 || y == 0 || x == width || y == height
        return 0
    end
    tree = map[y][x]
    see_up = ((y-1).downto(0).find_index {|i| map[i][x] >= tree} || (y-1)) + 1
    see_down = ((y+1..height).find_index {|i| map[i][x] >= tree} || (height-y-1)) + 1
    see_right = ((x+1..width).find_index {|i| map[y][i] >= tree} || (width-x-1)) + 1
    see_left =  ((x-1).downto(0).find_index {|i| map[y][i] >= tree} || (x-1)) + 1
    # binding.pry if x == 2 && y == 3
    return see_up * see_down * see_right * see_left
end
test_equals(scenic_score(0, 1, [[2,2,2],[2,2,2],[2,2,2]]), 0)
test_equals(scenic_score(1, 1, [[2,2,2],[2,2,2],[2,2,2],[2,2,2]]), 1)
test_equals(scenic_score(1, 1, [[2,2,2],[2,2,2],[2,1,2],[2,2,2]]), 2)
test_equals(scenic_score(1, 2, [[2,2,2],[2,1,2],[2,2,2],[2,2,2]]), 2)
test_equals(scenic_score(1, 1, [[2,2,2,2],[2,2,1,2],[2,2,2,2],[2,2,2,2]]), 2)
test_equals(scenic_score(2, 1, [[2,2,2,2],[2,1,2,2],[2,2,2,2],[2,2,2,2]]), 2)
test_equals(scenic_score(1, 1, [[2,2,2,2],[2,2,1,2],[2,1,2,2],[2,2,2,2]]), 4)
test_equals(scenic_score(2, 1, [[2,2,2,2],[1,1,2,2],[2,2,1,2],[2,2,2,2]]), 4)
test_equals(scenic_score(2, 2, [[2,2,1,2],[2,2,1,2],[2,1,2,2],[2,2,2,2]]), 4)

def highest_scenic_score(file_name)
    lines = read_file(file_name)
    map = lines.map {|line| line.split('').map {|x| x.to_i}}
    copy = lines.map {|line| line.split('').map {|x| x.to_i}}
    map.each_with_index {|row, y|
        row.each_with_index{|tree, x|
            score = scenic_score(x, y, map)
            copy[y][x] = score
        }
    }
    # binding.pry
    copy.flatten.max
end

test_equals(highest_scenic_score('input8-example.txt'), 8)
puts "part 2 #{highest_scenic_score('input8.txt')}"