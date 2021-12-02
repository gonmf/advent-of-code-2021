input = File.read('02.input').split("\n").map(&:strip)
# input = [
#   'forward 5',
#   'down 5',
#   'forward 8',
#   'up 3',
#   'down 8',
#   'forward 2'
# ]

# problem 1

x = 0
y = 0

input.each do |line|
  cmd, val = line.split(' ')

  val = val.to_i

  case cmd
  when 'forward'
    x += val
  when 'down'
    y += val
  when 'up'
    y -= val
  end
end

puts x * y

# problem 2

x = 0
y = 0
aim = 0

input.each do |line|
  cmd, val = line.split(' ')

  val = val.to_i

  case cmd
  when 'forward'
    x += val
    y += aim * val
  when 'down'
    aim += val
  when 'up'
    aim -= val
  end
end

puts x * y
