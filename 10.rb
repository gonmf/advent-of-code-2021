input = File.read('10.input').split("\n").map(&:strip)

# problem 1

SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}.freeze

INVERSE = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}.freeze

def parse_until_error(chars, last_opened = [])
  return [nil, last_opened] if chars.empty?

  head = chars[0]

  if INVERSE.keys.include?(head) # ending character
    return [head, []] unless last_opened.any? && INVERSE[head] == last_opened.last

    parse_until_error(chars[1..-1], last_opened[0...(last_opened.size - 1)])
  else # starting character
    parse_until_error(chars[1..-1], last_opened + [head])
  end
end

sum = 0

input.each.with_index do |line, line_idx|
  bad_char, left_over = parse_until_error(line.chars)
  next if left_over.any?

  score = SCORES[bad_char]

  sum += score
end

puts sum

# problem 2

SCORES2 = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}.freeze

all_scores = []

input.each.with_index do |line, line_idx|
  bad_char, left_over = parse_until_error(line.chars)
  next unless left_over.any?

  left_over = left_over.reverse.map { |c| INVERSE.invert[c] }

  score = 0

  left_over.each { |c| score = score * 5 + SCORES2[c] }

  all_scores.push(score)
end

puts all_scores.sort[all_scores.count / 2]
