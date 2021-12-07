input = File.read('07.input').split("\n").map(&:strip)

def fish_after_n_days(fish, n)
  day = 1

  fish_counts = { '0' => 0, '1' => 0, '2' => 0, '3' => 0, '4' => 0, '5' => 0, '6' => 0, '7' => 0, '8' => 0 }

  fish.each { |nr| fish_counts[nr.to_s] += 1 }

  while day <= n
    prev_0 = fish_counts['0']
    prev_8 = fish_counts['8']
    fish_counts['8'] = fish_counts['0']
    fish_counts['0'] = fish_counts['1']
    fish_counts['1'] = fish_counts['2']
    fish_counts['2'] = fish_counts['3']
    fish_counts['3'] = fish_counts['4']
    fish_counts['4'] = fish_counts['5']
    fish_counts['5'] = fish_counts['6']
    fish_counts['6'] = fish_counts['7'] + prev_0
    fish_counts['7'] = prev_8

    day += 1
  end

  fish_counts.values.sum
end

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
