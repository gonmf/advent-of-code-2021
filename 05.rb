input = File.read('05.input').split("\n").map(&:strip)

def sort(from, to)
  if from <= to
    [from, to]
  else
    [to, from]
  end
end

size = 1000

# problem 1

map = (0...size).map { (0..size).map { 0 } }

at_least_two = 0

input.each do |line|
  from, to = line.split(' -> ')
  from_x, from_y = from.split(',').map(&:to_i)
  to_x, to_y = to.split(',').map(&:to_i)

  from_y, to_y = sort(from_y, to_y)
  from_x, to_x = sort(from_x, to_x)

  if from_x == to_x # vertical
    while from_y <= to_y
      map[from_y][from_x] += 1
      at_least_two += 1 if map[from_y][from_x] == 2

      from_y += 1
    end
  elsif from_y == to_y # horizontal
    while from_x <= to_x
      map[from_y][from_x] += 1
      at_least_two += 1 if map[from_y][from_x] == 2

      from_x += 1
    end
  end
end

puts at_least_two

# problem 2

map = (0...size).map { (0..size).map { 0 } }

at_least_two = 0

input.each do |line|
  from, to = line.split(' -> ')
  from_x, from_y = from.split(',').map(&:to_i)
  to_x, to_y = to.split(',').map(&:to_i)

  x_change = from_x < to_x ? 1 : (from_x > to_x ? -1 : 0)
  y_change = from_y < to_y ? 1 : (from_y > to_y ? -1 : 0)

  while true
    map[from_y][from_x] += 1
    at_least_two += 1 if map[from_y][from_x] == 2

    break if from_x == to_x && from_y == to_y

    from_x += x_change
    from_y += y_change
  end
end

puts at_least_two

