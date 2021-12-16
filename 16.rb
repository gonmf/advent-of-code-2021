input = File.read('16.input').split("\n").map(&:strip)

# Problem 1

def hex_to_binary(c)
  ret = c.to_i(16).to_s(2).chars

  Array.new(4 - ret.count, '0') + ret
end

def calc_result(type_id, values)
  if type_id == 0
    values.sum
  elsif type_id == 1
    res = 1
    values.each { |v| res = res * v }
    res
  elsif type_id == 2
    values.min
  elsif type_id == 3
    values.max
  elsif type_id == 5
    values[0] > values[1] ? 1 : 0
  elsif type_id == 6
    values[0] < values[1] ? 1 : 0
  elsif type_id == 7
    values[0] == values[1] ? 1 : 0
  else
    raise 'invalid type ID'
  end
end

def log(s, depth)
  # puts "#{Array.new(depth, "\t").join}#{s}"
end

def read_packet_bin(bits, depth = 0)
  version = [bits[0], bits[1], bits[2]].join.to_i(2)
  type_id = [bits[3], bits[4], bits[5]].join.to_i(2)
  log("-----------------------", depth)
  log("Version #{version}", depth)
  log("Type ID #{type_id}", depth)

  sum_versions = version

  if type_id == 4
    # literal packet
    literal_bits = bits[6..-1]

    value = []
    bit_index = 0
    while true
      next_bits = literal_bits[(bit_index * 5)...((bit_index + 1) * 5)]
      value = value + next_bits[1..-1]
      bit_index += 1
      break if next_bits[0].to_i == 0
    end

    end_i = 6 + bit_index * 5

    value = value.join.to_i(2)
    log("decimal #{value}", depth)

    return [sum_versions, value, end_i]
  else
    # operator packet
    length_type_id = bits[6].to_i

    if length_type_id == 0
      total_length_in_bits = bits[7...22]
      total_length_in_bits = total_length_in_bits.join.to_i(2)
      log("operator with #{total_length_in_bits} bits", depth)

      results = []
      start_i = 22
      last_end_i = 0
      while total_length_in_bits > 0
        sum_versions2, subresult, end_i = read_packet_bin(bits[start_i..-1], depth + 1)

        results.push(subresult)
        last_end_i += end_i
        sum_versions += sum_versions2
        start_i += end_i
        total_length_in_bits -= end_i
      end

      return [sum_versions, calc_result(type_id, results), start_i]
    else
      number_of_subpackets = bits[7...18]
      number_of_subpackets = number_of_subpackets.join.to_i(2)
      log("operator with #{number_of_subpackets} packets", depth)

      results = []
      start_i = 18
      last_end_i = 0
      (0...number_of_subpackets).each do
        sum_versions2, subresult, end_i = read_packet_bin(bits[start_i..-1], depth + 1)

        results.push(subresult)
        last_end_i += end_i
        sum_versions += sum_versions2
        start_i += end_i
      end

      return [sum_versions, calc_result(type_id, results), start_i]
    end
  end
end

def read_packet(arr)
  bits = arr.map { |hex| hex_to_binary(hex) }.flatten

  read_packet_bin(bits)
end

sum_versions, result, = read_packet(input[0].chars)

puts sum_versions

# Problem 2

puts result

