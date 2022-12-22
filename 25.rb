lines = File.read('25.input').split("\n")

def step(map)
  max_x = map[0].count
  max_y = map.count
  can_move = map.map { |l| l.map { false } }
  any_moved = false

  map.each.with_index do |row, y|
    row.each.with_index do |c, x|
      if c == '>' && map.dig(y, (x + 1) % max_x) == '.'
        can_move[y][x] = true
        any_moved = true
      end
    end
  end

  map.each.with_index do |row, y|
    row.each.with_index do |c, x|
      if can_move.dig(y, x)
        map[y][x] = '.'
        map[y][(x + 1) % max_x] = '>'
        can_move[y][x] = false
      end
    end
  end

  map.each.with_index do |row, y|
    row.each.with_index do |c, x|
      if c == 'v' && map.dig((y + 1) % max_y, x) == '.'
        can_move[y][x] = true
        any_moved = true
      end
    end
  end

  map.each.with_index do |row, y|
    row.each.with_index do |c, x|
      if can_move.dig(y, x)
        map[y][x] = '.'
        map[(y + 1) % max_y][x] = 'v'
      end
    end
  end

  any_moved
end

map = lines.map { |l| l.chars }

i = 1
while step(map)
  i += 1
end

puts i
