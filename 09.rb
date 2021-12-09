input = File.read('09.input').split("\n").map(&:strip)

# problem 1

def height_at(arr, x, y)
  return nil if x < 0 || y < 0 || x >= arr[0].count || y >= arr.count

  arr[y][x]
end

def low_point?(arr, x, y)
  [[1, 0], [0, 1], [-1, 0], [0, -1]].all? do |x2, y2|
    v = height_at(arr, x + x2, y + y2)

    v.nil? || arr[y][x] < v
  end
end

arr = input.map { |line| line.chars.map(&:to_i) }

width = arr[0].count
height = arr.count

sum_risks = 0

(0...height).each do |y|
  (0...width).each do |x|
    if low_point?(arr, x, y)
      risk_level = 1 + arr[y][x]

      sum_risks += risk_level
    end
  end
end

puts sum_risks

# problem 2

def flow(arr, x, y, flow_counts)
  return if arr[y][x] == 9

  min_x = min_y = nil
  min_val = arr[y][x]

  [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |offset_x, offset_y|
    val = height_at(arr, offset_x + x, offset_y + y)
    next if val.nil?

    if min_val.nil? || min_val > val
      min_x = offset_x + x
      min_y = offset_y + y
      min_val = val
    end
  end

  return if min_val.nil?

  if min_x.nil?
    flow_counts[y][x] += 1
  else
    flow(arr, min_x, min_y, flow_counts)
  end
end

flow_counts = input.map { |line| line.chars.map { 0 } }

(0...height).each do |y|
  (0...width).each do |x|
    flow(arr, x, y, flow_counts)
  end
end

a, b, c = flow_counts.flatten.sort.last(3)
puts a * b * c

