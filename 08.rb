input = File.read('08.input').split("\n").map(&:strip)

# problem 1

sum = 0

input.each do |line|
  patterns, output = line.split(' | ')
  output = output.split(' ')

  sum += output.select { |p| [2, 4, 3, 7].include? p.size }.count
end

puts sum

# problem 2

ALL_DIGITS = %w[a b c d e f g].freeze
NUMBER_ENCODINGS = %w[abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg].freeze

def valid_match?(patterns, matches)
  patterns.all? do |pat|
    translated = pat.chars.map { |p| matches.invert[[p]] }.sort

    NUMBER_ENCODINGS.include?(translated.join)
  end
end

def complete?(matches)
  matches.values.all? { |v| v.count == 1 }
end

def associate(matches, number_chars, pattern_chars)
  other_nrs = ALL_DIGITS - number_chars
  number_chars.each do |chr|
    matches[chr] = matches[chr] & pattern_chars
  end

  other_nrs.each do |nr|
    matches[nr] = matches[nr] - pattern_chars
  end

  matches
end

def search_combo(patterns, matches)
  if complete?(matches)
    return valid_match?(patterns, matches) ? matches : nil
  end

  key = matches.keys.select { |k| matches[k].count == 2 }.first

  search_combo(patterns, associate(matches.clone, [key], [matches[key][0]])) ||
    search_combo(patterns, associate(matches.clone, [key], [matches[key][1]]))
end

final_sum = 0

input.each do |line|
  patterns, output = line.split(' | ')

  patterns = patterns.split(' ')
  output = output.split(' ')

  matches = {
    'a' => ALL_DIGITS,
    'b' => ALL_DIGITS,
    'c' => ALL_DIGITS,
    'd' => ALL_DIGITS,
    'e' => ALL_DIGITS,
    'f' => ALL_DIGITS,
    'g' => ALL_DIGITS
  }

  (patterns + output).each do |pattern|
    if pattern.size == 2 # one
      size_chars = ['c', 'f']
      matches = associate(matches, size_chars, pattern.chars)
    end
    if pattern.size == 3 # seven
      size_chars = ['a', 'c', 'f']
      matches = associate(matches, size_chars, pattern.chars)
    end
    if pattern.size == 4 # four
      size_chars = ['b', 'c', 'd', 'f']
      matches = associate(matches, size_chars, pattern.chars)
    end
  end

  matches = search_combo((patterns + output), matches)

  final_output = output.map do |pattern|
    translated = pattern.chars.map { |c| matches.invert[[c]] }.sort.join

    NUMBER_ENCODINGS.find_index { |n| n == translated }
  end.join.to_i

  final_sum += final_output
end

puts final_sum
