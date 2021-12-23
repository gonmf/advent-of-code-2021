input = File.read('22.input').split("\n").map(&:strip)

# Problem 1

CUBE_SIZE = 101

def set(cube, on_off, from_x, to_x, from_y, to_y, from_z, to_z)
  from_x = [from_x, 0].max
  to_x = [to_x, CUBE_SIZE - 1].min
  from_y = [from_y, 0].max
  to_y = [to_y, CUBE_SIZE - 1].min
  from_z = [from_z, 0].max
  to_z = [to_z, CUBE_SIZE - 1].min

  (from_z..to_z).each do |z|
    cube[z] ||= {}

    (from_y..to_y).each do |y|
      cube[z][y] ||= {}

      (from_x..to_x).each do |x|
        cube[z][y][x] = on_off
      end
    end
  end
end

cube = {}

input.each do |line|
  on_off, rest = line.split(' ')
  on_off = on_off == 'on'

  x_range, y_range, z_range = rest.split(',')
  from_x, to_x = x_range[2..-1].split('..')
  from_y, to_y = y_range[2..-1].split('..')
  from_z, to_z = z_range[2..-1].split('..')

  from_x = from_x.to_i + CUBE_SIZE / 2
  to_x = to_x.to_i + CUBE_SIZE / 2
  from_y = from_y.to_i + CUBE_SIZE / 2
  to_y = to_y.to_i + CUBE_SIZE / 2
  from_z = from_z.to_i + CUBE_SIZE / 2
  to_z = to_z.to_i + CUBE_SIZE / 2

  set(cube, on_off, from_x, to_x, from_y, to_y, from_z, to_z)
end

puts cube.values.map { |z| z.values.map { |y| y.values} }.flatten.count { |v| v }

# Problem 2

def sum_of_on_values(input, limit_from_x, limit_to_x, limit_from_y, limit_to_y, limit_from_z, limit_to_z, values_x, values_y, values_z)
  values_x = values_x.select { |x| limit_from_x <= x && x <= limit_to_x } + [values_x.find { |x| x > limit_to_x }].compact
  values_y = values_y.select { |y| limit_from_y <= y && y <= limit_to_y } + [values_y.find { |y| y > limit_to_y }].compact
  values_z = values_z.select { |z| limit_from_z <= z && z <= limit_to_z } + [values_z.find { |z| z > limit_to_z }].compact

  space = {}

  input.each.with_index do |line, line_i|
    on_off, rest = line.split(' ')
    on_off = on_off == 'on'

    x_range, y_range, z_range = rest.split(',')
    from_x, to_x = x_range[2..-1].split('..')
    from_y, to_y = y_range[2..-1].split('..')
    from_z, to_z = z_range[2..-1].split('..')

    from_x = [from_x.to_i, limit_from_x].max
    next if from_x > limit_to_x
    to_x = [to_x.to_i, limit_to_x].min
    next if to_x < limit_from_x

    from_y = [from_y.to_i, limit_from_y].max
    next if from_y > limit_to_y
    to_y = [to_y.to_i, limit_to_y].min
    next if to_y < limit_from_y

    from_z = [from_z.to_i, limit_from_z].max
    next if from_z > limit_to_z
    to_z = [to_z.to_i, limit_to_z].min
    next if to_z < limit_from_z

    if on_off
      values_z.select { |z| from_z <= z && z <= to_z }.each do |z|
        space[z] ||= {}

        values_y.select { |y| from_y <= y && y <= to_y }.each do |y|
          space[z][y] ||= {}

          values_x.select { |x| from_x <= x && x <= to_x }.each do |x|
            space[z][y][x] = true
          end
        end
      end
    else
      values_z.select { |z| from_z <= z && z <= to_z }.each do |z|
        next if space[z].nil?

        values_y.select { |y| from_y <= y && y <= to_y }.each do |y|
          next if space[z][y].nil?

          values_x.select { |x| from_x <= x && x <= to_x }.each do |x|
            space[z][y].delete(x)
          end
        end
      end
    end
  end

  sum = 0

  values_z.each.with_index do |z, i_z|
    values_y.each.with_index do |y, i_y|
      values_x.each.with_index do |x, i_x|
        next unless space.dig(z, y, x)

        from_x = x
        to_x = values_x[i_x + 1] || (x + 1)

        from_y = y
        to_y = values_y[i_y + 1] || (y + 1)

        from_z = z
        to_z = values_z[i_z + 1] || (z + 1)

        sum += (to_x - from_x) * (to_y - from_y) * (to_z - from_z)
      end
    end
  end

  sum
end

values_x = []
values_y = []
values_z = []

input.each do |line|
  on_off, rest = line.split(' ')
  on_off = on_off == 'on'

  x_range, y_range, z_range = rest.split(',')
  from_x, to_x = x_range[2..-1].split('..')
  from_y, to_y = y_range[2..-1].split('..')
  from_z, to_z = z_range[2..-1].split('..')

  from_x = from_x.to_i
  to_x = to_x.to_i
  from_y = from_y.to_i
  to_y = to_y.to_i
  from_z = from_z.to_i
  to_z = to_z.to_i

  values_x = (values_x + [from_x, to_x, to_x + 1]).uniq.sort
  values_y = (values_y + [from_y, to_y, to_y + 1]).uniq.sort
  values_z = (values_z + [from_z, to_z, to_z + 1]).uniq.sort
end

mid_x = (values_x[(input.count / 2) * 3])
mid_y = (values_y[(input.count / 2) * 3])
mid_z = (values_z[(input.count / 2) * 3])

sum = sum_of_on_values(input, values_x.min - 1, mid_x,     values_y.min - 1, mid_y,     values_z.min - 1, mid_z,     values_x, values_y, values_z) +
      sum_of_on_values(input, mid_x + 1, values_x.max + 1, values_y.min - 1, mid_y,     values_z.min - 1, mid_z,     values_x, values_y, values_z) +
      sum_of_on_values(input, values_x.min - 1, mid_x,     mid_y + 1, values_y.max + 1, values_z.min - 1, mid_z,     values_x, values_y, values_z) +
      sum_of_on_values(input, mid_x + 1, values_x.max + 1, mid_y + 1, values_y.max + 1, values_z.min - 1, mid_z,     values_x, values_y, values_z) +
      sum_of_on_values(input, values_x.min - 1, mid_x,     values_y.min - 1, mid_y,     mid_z + 1, values_z.max + 1, values_x, values_y, values_z) +
      sum_of_on_values(input, mid_x + 1, values_x.max + 1, values_y.min - 1, mid_y,     mid_z + 1, values_z.max + 1, values_x, values_y, values_z) +
      sum_of_on_values(input, values_x.min - 1, mid_x,     mid_y + 1, values_y.max + 1, mid_z + 1, values_z.max + 1, values_x, values_y, values_z) +
      sum_of_on_values(input, mid_x + 1, values_x.max + 1, mid_y + 1, values_y.max + 1, mid_z + 1, values_z.max + 1, values_x, values_y, values_z)

puts sum
