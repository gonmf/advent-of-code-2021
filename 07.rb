input = File.read('07.input').split("\n").map(&:strip)

# problem 1

elems = input[0].split(',').map(&:to_i)

min = elems.min
max = elems.max

min_pos = -1
min_cost = -1

(min..max).each do |val|
  cost = elems.map { |e| (e - val).abs }.sum

  if min_pos == -1 || cost < min_cost
    min_pos = val
    min_cost = cost
  end
end

puts min_cost

# problem 2

def movement_cost(distance, memo)
  memo[distance] ||= begin
    cost = 1
    total = 0

    while distance > 0
      distance -= 1
      total += cost
      cost += 1
    end

    total
  end
end

memo = {}
elems = input[0].split(',').map(&:to_i)

min = elems.min
max = elems.max

min_pos = -1
min_cost = -1

(min..max).each do |val|
  cost = elems.map { |e| movement_cost((e - val).abs, memo) }.sum

  if min_pos == -1 || cost < min_cost
    min_pos = val
    min_cost = cost
  end
end

puts min_cost
