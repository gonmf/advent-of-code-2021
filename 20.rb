input = File.read('20.input').split("\n").map(&:strip)

# Problem 1

def combine(map, x, y, odd)
  out = ''

  y2 = y - 1

  while y2 <= y + 1
    x2 = x - 1

    while x2 <= x + 1
      c = x2 >= 0 && y2 >= 0 && x2 < map.count && y2 < map.count ? map[y2][x2] : (odd ? '#' : '.')

      out += c

      x2 += 1
    end

    y2 += 1
  end

  out
end

def expand(map, iea, odd)
  output_map = Array.new(map.count + 2).map { Array.new(map.count + 2, nil) }

  output_map.each.with_index do |line, y|
    line.each.with_index do |c, x|
      c2 = combine(map, x - 1, y - 1, odd)

      i2 = c2.tr('.#', '01').to_i(2)

      output_map[y][x] = iea[i2]
    end
  end

  output_map
end

iea = input[0]

img = input[2..-1].map { |l| l.chars }

steps = 0

while steps < 2
  img = expand(img, iea, (steps % 2) == 1)

  steps += 1
end

puts img.map { |l| l.count { |c| c == '#' } }.sum

# problem 2

while steps < 50
  img = expand(img, iea, (steps % 2) == 1)

  steps += 1
end

puts img.map { |l| l.count { |c| c == '#' } }.sum
