input = File.read('17.input').split("\n").map(&:strip)

# Problem 1

def hits_target_area(target_x_from, target_x_to, target_y_from, target_y_to, dir_x, dir_y)
  pos_x = 0
  pos_y = 0
  max_y = nil

  while true
    return max_y if pos_x >= target_x_from && pos_x <= target_x_to && pos_y >= target_y_from && pos_y <= target_y_to
    return nil if pos_x > target_x_to || pos_y < target_y_from

    max_y = max_y.nil? ? pos_y : [max_y, pos_y].max

    pos_x += dir_x
    pos_y += dir_y

    dir_x = dir_x == 0 ? 0 : (dir_x > 0 ? dir_x - 1 : dir_x + 1)
    dir_y -= 1
  end
end

_, _, x_part, y_part = input[0].split(' ')
x_from, x_to = x_part.split('=')[1].split(',')[0].split('..')
y_from, y_to = y_part.split('=')[1].split('..')
x_from = x_from.to_i
x_to = x_to.to_i
y_from = y_from.to_i
y_to = y_to.to_i

puts (1..200).map { |y| (1..200).map { |x| hits_target_area(x_from, x_to, y_from, y_to, x, y) } }.flatten.compact.max

# problem 2

solutions = 0

puts (-100..200).map { |y| (1..200).select { |x| hits_target_area(x_from, x_to, y_from, y_to, x, y) }.count }.sum
