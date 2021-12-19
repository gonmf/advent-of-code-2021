input = File.read('19.input').split("\n").map(&:strip)

# Problem 1

scanners = {}
curr_scanner = -1

input.each do |line|
  if line.start_with?('---')
    curr_scanner = line.split(' ')[2].to_i
    scanners[curr_scanner] = []
  elsif line.size > 0
    scanners[curr_scanner].push(line.split(',').map(&:to_i))
  end
end

def product(a1, a2, a3 = [nil])
  ret = []

  a3.each do |e3|
    a2.each do |e2|
      a1.each do |e1|
        ret.push([e1, e2, e3].compact)
      end
    end
  end

  ret.uniq
end

def possible_orientations
  @possible_orientations ||= begin
    o = [0, 90, 180, 270]

    product(o, o, o)
  end
end

def rotate(angle, x, y)
  @rotations_memo ||= {}
  @rotations_memo[angle] ||= {}
  @rotations_memo[angle][x] ||= {}
  @rotations_memo[angle][x][y] ||= begin
    if angle == 0
      [x, y]
    elsif angle == 90
      [-y, x]
    elsif angle == 180
      [-x, -y]
    else
      [y, -x]
    end
  end
end

def transform(beacons, orientation)
  angle_xy, angle_yz, angle_xz = orientation

  new_beacons = []

  beacons.each do |beacon|
    x, y, z = beacon
    x, y = rotate(angle_xy, x, y)
    x, z = rotate(angle_xz, x, z)
    y, z = rotate(angle_yz, y, z)

    new_beacons.push([x, y, z])
  end

  new_beacons
end

def normalize_by_pivot(beacons, beacon_pivot1, beacon_pivot2)
  diff_x = beacon_pivot2[0] - beacon_pivot1[0]
  diff_y = beacon_pivot2[1] - beacon_pivot1[1]
  diff_z = beacon_pivot2[2] - beacon_pivot1[2]

  beacons.map { |x, y, z| [x + diff_x, y + diff_y, z + diff_z] }
end

def find_orientation(beacons, prev_beacons)
  best_matching_beacons_count = -1
  best_all_norm_beacons = nil

  possible_orientations.each do |orientation|
    transformed_beacons = transform(beacons, orientation)

    transformed_beacons.each do |beacon_pivot1|
      prev_beacons.each do |beacon_pivot2|
        norm_beacons = normalize_by_pivot(transformed_beacons, beacon_pivot1, beacon_pivot2)

        beacons_matched = (norm_beacons & prev_beacons)
        matching_beacons_count = beacons_matched.count

        if matching_beacons_count >= 12
          scanner_pos, = normalize_by_pivot([[0, 0, 0]], beacon_pivot1, beacon_pivot2)

          return [matching_beacons_count, norm_beacons, scanner_pos]
        end
      end
    end
  end

  nil
end

total_beacons = scanners[0]
left = scanners.keys - [0]
scanner_positions = []

while left.any?
  next_left = []

  left.each do |scanner_id|
    beacons = scanners[scanner_id]

    matched_count, all_beacons_normalized, scanner_pos = find_orientation(beacons, total_beacons)
    if all_beacons_normalized.nil?
      next_left.push(scanner_id)
      next
    end

    scanner_positions.push(scanner_pos)

    total_beacons = (total_beacons + all_beacons_normalized).uniq
  end

  left = next_left
end

puts total_beacons.count

# problem 2

max_distance = 0

scanner_positions.each do |pos1|
  scanner_positions.each do |pos2|
    x1, y1, z1 = pos1
    x2, y2, z2 = pos2

    distance = (x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs

    max_distance = [max_distance, distance].max
  end
end

puts max_distance
