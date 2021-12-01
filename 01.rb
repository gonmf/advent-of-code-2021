input = File.read('01.input').split("\n").map(&:strip).map(&:to_i)
# input = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

# problem 1

increases = 0
i = 1

while i < input.count
  increases += 1 if input[i - 1] < input[i]

  i += 1
end

puts increases


# problem 2

increases = 0
i = 2
last_window_sum = -1

while i < input.count
  window_sum = input[i - 2] + input[i - 1] + input[i]

  increases += 1 if last_window_sum != -1 && window_sum > last_window_sum

  last_window_sum = window_sum

  i += 1
end

puts increases
