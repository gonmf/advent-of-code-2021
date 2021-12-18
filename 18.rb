input = File.read('18.input').split("\n").map(&:strip)

# Problem 1

class Num
  attr_accessor :v

  def initialize(val)
    @v = val&.to_i
  end
end

def parse_number(str)
  str = str.chars.select { |c| c != ' ' } if str.is_a?(String)

  if str[0] == '['
    number1, offset1 = parse_number(str[1..-2])
    offset1 += 2

    number2, offset2 = parse_number(str[offset1..-2])

    [[number1, number2], offset1 + offset2 + 1]
  else
    s1 = str.join.split(',')[0]
    s2 = str.join.split(']')[0]
    s = s1.size > s2.size ? s2 : s1

    [Num.new(s), s.size]
  end
end

def increment_by_flat_index(tree, update_i, update_val, i = [0])
  if tree.is_a?(Array)
    return if update_i < i[0]

    increment_by_flat_index(tree[0], update_i, update_val, i)
    increment_by_flat_index(tree[1], update_i, update_val, i)
  else
    if i[0] == update_i
      tree.v += update_val.v
    end

    i[0] = i[0] + 1
  end
end

def explode_once(original_n, n, depth = 1)
  return [false, n] unless n.is_a?(Array)

  left, right = n

  if depth > 4
    n[0] = nil
    curr_idx = original_n.to_a.flatten.index(nil)
    n[0] = left

    increment_by_flat_index(original_n, curr_idx - 1, left) if curr_idx > 0
    increment_by_flat_index(original_n, curr_idx + 2, right)
    return [true, Num.new(0)]
  end

  exploded, new_left = explode_once(original_n, left, depth + 1)
  return [true, [new_left, right]] if exploded

  exploded, new_right = explode_once(original_n, right, depth + 1)
  return [true, [left, new_right]] if exploded

  [false, n]
end

def split_once(n)
  if !n.is_a?(Array)
    if n.v > 9
      val = n.v / 2

      return [true, [Num.new(val), Num.new(n.v - val)]]
    end

    return [false, n]
  end

  left, right = n

  split_left, n_left = split_once(left)
  if split_left
    return [true, [n_left, right]]
  end

  split_right, n_right = split_once(right)
  if split_right
    return [true, [left, n_right]]
  end

  [false, n]
end

def reduce_number(n)
  exploded, n2 = explode_once(n, n)
  return reduce_number(n2) if exploded

  splitted, n2 = split_once(n)
  return reduce_number(n2) if splitted

  n
end

def add_numbers(n1, n2)
  reduce_number([n1, n2])
end

def magnitude(n)
  return n.v if n.is_a?(Num)

  magnitude(n[0]) * 3 + magnitude(n[1]) * 2
end

def deep_clone(n)
  if n.is_a?(Array)
    n.map { |v| deep_clone(v) }
  else
    Num.new(n.v)
  end
end

numbers = []

input.each do |line|
  number, = parse_number(line)

  numbers.push(number)
end

result = deep_clone(numbers[0])

numbers[1..-1].each do |number|
  result = add_numbers(result, deep_clone(number))
end

puts magnitude(result)

# problem 2

max_magnitude = 0

numbers.each.with_index do |n1, i1|
  numbers.each.with_index do |n2, i2|
    next if i1 == i2

    result = add_numbers(deep_clone(n1), deep_clone(n2))
    max_magnitude = [max_magnitude, magnitude(result)].max
  end
end

puts max_magnitude
