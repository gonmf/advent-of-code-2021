input = File.read('03.input').split("\n").map(&:strip)

# problem 1

counts = []

input.each do |line|
  bits = line.chars

  bits.each.with_index do |bit, i|
    if bit == '1'
      counts[i] = (counts[i] || 0) + 1
    else
      counts[i] = (counts[i] || 0) - 1
    end
  end
end

gamma_rate = counts.map { |count| count > 0 ? '1' : '0' }.join.to_i(2)
epsilon_rate = counts.map { |count| count > 0 ? '0' : '1' }.join.to_i(2)

power_comsumption = gamma_rate * epsilon_rate

puts power_comsumption

# problem 2

rows = input.map(&:chars)
i = 0

while rows.count > 1
  new_rows = rows.select { |r| r[i] == '1' }

  if new_rows.count * 2 >= rows.count
    rows = new_rows
  else
    rows = rows - new_rows
  end

  i += 1
end

oxygen_generator_rating = rows[0].join.to_i(2)

rows = input.map(&:chars)
i = 0

while rows.count > 1
  new_rows = rows.select { |r| r[i] == '0' }

  if new_rows.count * 2 <= rows.count
    rows = new_rows
  else
    rows = rows - new_rows
  end

  i += 1
end

co2_scrubber_rating = rows[0].join.to_i(2)

life_support_rating = oxygen_generator_rating * co2_scrubber_rating

puts life_support_rating
