# problem 1

input = File.read('04.input').split("\n").map(&:strip)

drawn = input[0].split(',').map(&:to_i)

input = input[1..]

boards = []
i = 0

input.select { |l| l.size > 0 }.each do |line|
  board_i = i / 5
  boards[board_i] ||= []
  boards[board_i].push(line.split(' ').map(&:to_i))

  i += 1
end

finished = nil

drawn.each do |drawn_nr|
  boards = boards.map.with_index do |board, board_i|
    new_board = board.map do |row|
      new_row = row.map do |row_nr|
        row_nr == drawn_nr ? -1 : row_nr
      end

      if new_row.all? { |row_nr| row_nr == -1 }
        finished = board_i
      end

      new_row
    end

    (0...5).each do |column|
      if new_board.all? { |row| row[column] == -1 }
        finished = board_i
        break
      end
    end

    new_board
  end

  if finished
    score = boards[finished].map { |row| row.map { |nr| nr > 0 ? nr : 0 }.sum }.sum * drawn_nr
    puts score

    break
  end
end

# problem 2

input = File.read('04.input').split("\n").map(&:strip)

drawn = input[0].split(',').map(&:to_i)

input = input[1..]

boards = []
i = 0

input.select { |l| l.size > 0 }.each do |line|
  board_i = i / 5
  boards[board_i] ||= []
  boards[board_i].push(line.split(' ').map(&:to_i))

  i += 1
end

finished = []

drawn.each do |drawn_nr|
  boards = boards.map.with_index do |board, board_i|
    new_board = board.map do |row|
      new_row = row.map do |row_nr|
        row_nr == drawn_nr ? -1 : row_nr
      end

      if new_row.all? { |row_nr| row_nr == -1 }
        finished.push(board_i)
      end

      new_row
    end

    (0...5).each do |column|
      if new_board.all? { |row| row[column] == -1 }
        finished = (finished + [board_i]).uniq
      end
    end

    new_board
  end

  if finished.any?
    if boards.count > 1
      boards = boards - finished.map { |i| boards[i] }
    else
      sum = boards[0].map { |row| row.map { |nr| nr > 0 ? nr : 0 }.sum }.sum
      puts sum * drawn_nr

      break
    end
  end

  finished = []
end

