input = File.read('11.input').split("\n").map(&:strip)

# problem 1

MAP_SIZE = 10

def valid_coord?(x, y)
  x >= 0 && x < MAP_SIZE && y >= 0 && y < MAP_SIZE
end

arr = input.map { |line| line.chars.map(&:to_i) }
flashed = (0...MAP_SIZE).map { (0...MAP_SIZE).map { false } }
step = 0
total_flashes = 0

while step < 100
  (0...MAP_SIZE).each do |y|
    (0...MAP_SIZE).each do |x|
      arr[y][x] += 1
    end
  end

  repeat = true
  while repeat
    repeat = false

    (0...MAP_SIZE).each do |y|
      (0...MAP_SIZE).each do |x|
        next if flashed[y][x]

        if arr[y][x] > 9
          flashed[y][x] = true
          total_flashes += 1

          [[1, 1], [1, 0], [0, 1], [-1, 0], [-1, -1], [0, -1], [1, -1], [-1, 1]].each do |offset_x, offset_y|
            x2 = x + offset_x
            y2 = y + offset_y

            if valid_coord?(x2, y2)
              arr[y2][x2] += 1

              repeat = true
            end
          end
        end
      end
    end
  end

  (0...MAP_SIZE).each do |y|
    (0...MAP_SIZE).each do |x|
      if flashed[y][x]
        arr[y][x] = 0
        flashed[y][x] = false
      end
    end
  end

  step += 1
end

puts total_flashes

# problem 2

arr = input.map { |line| line.chars.map(&:to_i) }
flashed = (0...MAP_SIZE).map { (0...MAP_SIZE).map { false } }
step = 0

while true
  (0...MAP_SIZE).each do |y|
    (0...MAP_SIZE).each do |x|
      arr[y][x] += 1
    end
  end

  repeat = true
  while repeat
    repeat = false

    (0...MAP_SIZE).each do |y|
      (0...MAP_SIZE).each do |x|
        next if flashed[y][x]

        if arr[y][x] > 9
          flashed[y][x] = true

          [[1, 1], [1, 0], [0, 1], [-1, 0], [-1, -1], [0, -1], [1, -1], [-1, 1]].each do |offset_x, offset_y|
            x2 = x + offset_x
            y2 = y + offset_y

            if valid_coord?(x2, y2)
              arr[y2][x2] += 1

              repeat = true
            end
          end
        end
      end
    end
  end

  break if flashed.all? { |line| line.all? { |v| v } }

  (0...MAP_SIZE).each do |y|
    (0...MAP_SIZE).each do |x|
      if flashed[y][x]
        arr[y][x] = 0
        flashed[y][x] = false
      end
    end
  end

  step += 1
end

puts step + 1
