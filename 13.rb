input = File.read('13.input').split("\n").map(&:strip)

width = 0
height = 0

input.each do |line|
  break if line.empty?

  x, y = line.split(',')
  width = [width, x.to_i + 1].max
  height = [height, y.to_i + 1].max
end

# problem 1

arr = (0...height).map { Array.new(width, 0) }
fold = false

input.each do |line|
  if line.empty? && !fold
    fold = true
    next
  end

  if !fold
    x, y = line.split(',')
    arr[y.to_i][x.to_i] = 1
    next
  end

  fold_axis, fold_line = line.split('=')
  fold_axis = fold_axis.chars.last
  fold_line = fold_line.to_i

  if fold_axis == 'x'
    new_arr = (0...arr.count).map { Array.new(fold_line, 0) }

    arr.each.with_index do |line, y|
      line.each.with_index do |_, x|
        next if x == fold_line

        x2 = (x > fold_line ? fold_line + fold_line - x : x)
        new_arr[y][x2] = [new_arr[y][x2], arr[y][x]].max
      end
    end

    arr = new_arr
    break
  end
end

puts arr.map { |l| l.sum }.sum

# problem 2

arr = (0...height).map { Array.new(width, 0) }
fold = false

input.each do |line|
  if line.empty? && !fold
    fold = true
    next
  end

  if !fold
    x, y = line.split(',')
    arr[y.to_i][x.to_i] = 1
    next
  end

  fold_axis, fold_line = line.split('=')
  fold_axis = fold_axis.chars.last
  fold_line = fold_line.to_i

  if fold_axis == 'y'
    new_arr = (0...fold_line).map { Array.new(arr[0].count, 0) }

    arr.each.with_index do |line, y|
      next if y == fold_line

      y2 = (y > fold_line ? fold_line + fold_line - y : y)

      line.each.with_index do |_, x|
        new_arr[y2][x] = [new_arr[y2][x], arr[y][x]].max
      end
    end

    arr = new_arr
  end

  if fold_axis == 'x'
    new_arr = (0...arr.count).map { Array.new(fold_line, 0) }

    arr.each.with_index do |line, y|
      line.each.with_index do |_, x|
        next if x == fold_line

        x2 = (x > fold_line ? fold_line + fold_line - x : x)
        new_arr[y][x2] = [new_arr[y][x2], arr[y][x]].max
      end
    end

    arr = new_arr
  end
end

arr.each { |l| puts l.map { |c| c == 0 ? '.' : '#' }.join }
