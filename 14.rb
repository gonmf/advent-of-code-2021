input = File.read('14.input').split("\n").map(&:strip)

# problem 1

template = input[0]

rules = []

input[2..-1].each do |rule|
  pattern, insert = rule.split(' -> ')

  rules.push([pattern, insert])
end

step = 0
while step < 10
  step += 1

  rules.each do |rule|
    pattern, insert = rule

    while template.include?(pattern)
      template = template.sub(pattern, "#{pattern[0]}[#{insert}]#{pattern[1]}")
    end
  end

  rules.each do |rule|
    pattern, insert = rule

    template = template.gsub("[#{insert}]", insert)
  end
end

elements = {}
template.chars.each do |c|
  elements[c] = (elements[c] || 0) + 1
end

puts elements.values.max - elements.values.min

# problem 2

template = input[0].clone

def expand(goal_steps, str, rules, memo)
  memo[goal_steps] ||= {}
  memo[goal_steps][str] ||= begin
    outcome = {}

    if goal_steps == 0
      str.chars[1..-1].each do |ch|
        outcome[ch] = (outcome[ch] || 0) + 1
      end

      return outcome
    end

    ichars = str.chars
    ichars[1..-1].each.with_index do |c2, i|
      c1 = ichars[i]

      new_str = "#{c1}#{c2}"

      matching_rule = rules.find { |rule| rule[0] == new_str }

      if matching_rule
        new_str = "#{c1}#{matching_rule[1]}#{c2}"

        sub_outcome = expand(goal_steps - 1, new_str, rules, memo)

        sub_outcome.each do |ch, count|
          outcome[ch] = (outcome[ch] || 0) + count
        end
      else
        new_str.chars[1..-1].each do |ch|
          outcome[ch] = (outcome[ch] || 0) + 1
        end
      end
    end

    outcome
  end
end

outcome = expand(40, template.clone, rules, {})
outcome[template[0]] += 1

puts outcome.values.max - outcome.values.min
