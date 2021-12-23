# Problem 1

COSTS = {
  'A' => 1,
  'B' => 10,
  'C' => 100,
  'D' => 1000
}

def draw(map)
  map.each do |line|
    puts line.map { |c| [true, false].include?(c) ? (c ? 'x' : '.') : c }.join
  end
  puts
end

def finished(map)
  'a' == map[2][3] && 'a' == map[3][3] &&
    'b' == map[2][5] && 'b' == map[3][5] &&
    'c' == map[2][7] && 'c' == map[3][7] &&
    'd' == map[2][9] && 'd' == map[3][9]
end

def apply_move_to_map(map, move)
  map = map.map { |l| l.dup }

  from_x, from_y, to_x, to_y, move_cost = move

  c = map[from_y][from_x]
  map[from_y][from_x] = '.'

  map[to_y][to_x] = in_final_room(c, to_x, to_y) ? c.downcase : c

  map
end

def in_hallway(x, y)
  y == 1
end

def in_any_room(x, y)
  y > 1
end

def in_final_room(c, x, y)
  return false unless in_any_room(x, y)

  x2 = (c.ord - 'A'.ord) * 2 + 3
  x == x2
end

def room_has_no_foreign_types(map, c, x, y)
  [c, c.downcase, '.'].include?(map[2][x]) && [c, c.downcase, '.'].include?(map[3][x])
end

def calc_reachable(reachable_map, map, x, y, distance = 0)
  reachable_map[y][x] = distance

  if x > 0 && reachable_map[y][x - 1] == -1 && map[y][x - 1] == '.'
    calc_reachable(reachable_map, map, x - 1, y, distance + 1)
  end

  if x < map[0].count - 1 && reachable_map[y][x + 1] == -1 && map[y][x + 1] == '.'
    calc_reachable(reachable_map, map, x + 1, y, distance + 1)
  end

  if y > 0 && reachable_map[y - 1][x] == -1 && map[y - 1][x] == '.'
    calc_reachable(reachable_map, map, x, y - 1, distance + 1)
  end

  if y < map.count - 1 && reachable_map[y + 1][x] == -1 && map[y + 1][x] == '.'
    calc_reachable(reachable_map, map, x, y + 1, distance + 1)
  end
end

def possible_moves(map, c, x, y)
  # draw(map)

  reachable_map = map.map { |l| l.map { -1 } }
  calc_reachable(reachable_map, map, x, y)

  reachable_map[1][3] = -1
  reachable_map[1][5] = -1
  reachable_map[1][7] = -1
  reachable_map[1][9] = -1

  if map[3][3] == '.'
    reachable_map[2][3] = -1
  end
  if map[3][5] == '.'
    reachable_map[2][5] = -1
  end
  if map[3][7] == '.'
    reachable_map[2][7] = -1
  end
  if map[3][9] == '.'
    reachable_map[2][9] = -1
  end

  reachable_moves = []
  reachable_map.each.with_index do |l, y2|
    l.each.with_index do |c, x2|
      if c > 0
        reachable_moves.push([x2, y2])
      end
    end
  end

  in_hall = in_hallway(x, y)
  moves =
    if in_hall
      reachable_moves.select { |x2, y2| in_final_room(c, x2, y2) && room_has_no_foreign_types(map, c, x2, y2) }
    else
      direct_to_room = reachable_moves.select { |x2, y2| in_final_room(c, x2, y2) && room_has_no_foreign_types(map, c, x2, y2) }

      if direct_to_room.any?
        direct_to_room
      else
        reachable_moves.select { |x2, y2| in_hallway(x2, y2) }
      end
    end

  moves.map { |x2, y2| [x, y, x2, y2, COSTS[map[y][x]] * reachable_map[y2][x2]] }
end

def search(map, cost, result)
  [
    [3, 2], [5, 2], [7, 2], [9, 2],
    [3, 3], [5, 3], [7, 3], [9, 3]
  ].each do |x, y|
    c = map[y][x]

    if %[A B C D].include?(c)
      if in_final_room(c, x, y)
        if y == 3
          map[3][x] = c.downcase
        elsif [c, c.downcase].include?(map[3][x])
          map[2][x] = c.downcase
        end
      end
    end
  end

  if finished(map)
    if result[0].nil? || result[0] > cost
      result[0] = cost
    end

    return
  end

  all_moves = []

  map.each.with_index do |line, i_y|
    line.each.with_index do |c, i_x|
      if %[A B C D].include?(c)
        moves = possible_moves(map, c, i_x, i_y)

        all_moves = all_moves + moves
      end
    end
  end

  all_moves.shuffle.each.with_index do |move, move_i|
    from_x, from_y, to_x, to_y, move_cost = move

    new_cost = cost + move_cost

    if result[0].nil? || result[0] > new_cost
      search(apply_move_to_map(map, move), new_cost, result)
    end
  end
end

input = File.read('23.input').split("\n")

map = input.map { |l | l.chars }

result = []
search(map, 0, result)
puts result[0]

# Solution: 19046

# Problem 2

def finished(map)
  'a' == map[2][3] && 'a' == map[3][3] && 'a' == map[4][3] && 'a' == map[5][3] &&
    'b' == map[2][5] && 'b' == map[3][5] && 'b' == map[4][5] && 'b' == map[5][5] &&
    'c' == map[2][7] && 'c' == map[3][7] && 'c' == map[4][7] && 'c' == map[5][7] &&
    'd' == map[2][9] && 'd' == map[3][9] && 'd' == map[4][9] && 'd' == map[4][9]
end

def room_has_no_foreign_types(map, c, x, y)
  [c, c.downcase, '.'].include?(map[2][x]) && [c, c.downcase, '.'].include?(map[3][x]) &&
    [c, c.downcase, '.'].include?(map[4][x]) && [c, c.downcase, '.'].include?(map[5][x])
end

def search(map, cost, result)
  [
    [3, 2], [5, 2], [7, 2], [9, 2],
    [3, 3], [5, 3], [7, 3], [9, 3],
    [3, 4], [5, 4], [7, 4], [9, 4],
    [3, 5], [5, 5], [7, 5], [9, 5]
  ].each do |x, y|
    c = map[y][x]

    if %[A B C D].include?(c)
      if in_final_room(c, x, y)
        if y == 5
          map[5][x] = c.downcase
        elsif c.downcase == map[y + 1][x]
          map[y][x] = c.downcase
        end
      end
    end
  end

  if finished(map)
    if result[0].nil? || result[0] > cost
      result[0] = cost
    end

    return
  end

  all_moves = []

  map.each.with_index do |line, i_y|
    line.each.with_index do |c, i_x|
      if %[A B C D].include?(c)
        moves = possible_moves(map, c, i_x, i_y)

        all_moves = all_moves + moves
      end
    end
  end

  all_moves.shuffle.each.with_index do |move, move_i|
    from_x, from_y, to_x, to_y, move_cost = move

    new_cost = cost + move_cost

    if result[0].nil? || result[0] > new_cost
      search(apply_move_to_map(map, move), new_cost, result)
    end
  end
end

input = File.read('23_2.input').split("\n")

map = input.map { |l | l.chars }

result = []
search(map, 0, result)
puts result[0]
