input = File.read('06.input').split("\n").map(&:strip)

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

fish = input[0].split(',').map(&:to_i)

puts fish_after_n_days(fish, 80)

# problem 2

fish = input[0].split(',').map(&:to_i)

puts fish_after_n_days(fish, 256)

