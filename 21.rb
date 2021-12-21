input = File.read('21.input').split("\n").map(&:strip)

# Problem 1

player1_pos = input[0].split(' starting position: ')[1].to_i
player2_pos = input[1].split(' starting position: ')[1].to_i

player1_score = 0
player2_score = 0

@rolls = 0

def deterministic_dice
  @rolls += 1
  @deterministic_dice = ((@deterministic_dice.to_i % 100) + 1)
end

while true
  player1_pos = ((player1_pos + deterministic_dice + deterministic_dice + deterministic_dice - 1) % 10) + 1
  player1_score += player1_pos

  break if player1_score >= 1000

  player2_pos = ((player2_pos + deterministic_dice + deterministic_dice + deterministic_dice - 1) % 10) + 1
  player2_score += player2_pos

  break if player2_score >= 1000
end

puts (player1_score >= 1000 ? player2_score : player1_score) * @rolls

# problem 2

def product(a1, a2, a3)
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

def dice_triplets
  @dice_triplets ||= product([1, 2, 3], [1, 2, 3], [1, 2, 3]).map(&:sum)
end

def wins(player1_pos, player2_pos, player1_score, player2_score, player1_turn, memo)
  return [1, 0] if player1_score >= 21
  return [0, 1] if player2_score >= 21

  memo[player1_turn] ||= {}
  memo[player1_turn][player1_pos] ||= {}
  memo[player1_turn][player1_pos][player2_pos] ||= {}
  memo[player1_turn][player1_pos][player2_pos][player1_score] ||= {}
  memo[player1_turn][player1_pos][player2_pos][player1_score][player2_score] ||= begin
    player1_wins = 0
    player2_wins = 0

    dice_triplets.each do |val|
      if player1_turn
        new_pos = ((player1_pos + val - 1) % 10) + 1

        player1_wins2, player2_wins2 = wins(new_pos, player2_pos, player1_score + new_pos, player2_score, false, memo)
      else
        new_pos = ((player2_pos + val - 1) % 10) + 1

        player1_wins2, player2_wins2 = wins(player1_pos, new_pos, player1_score, player2_score + new_pos, true, memo)
      end

      player1_wins += player1_wins2
      player2_wins += player2_wins2
    end

    [player1_wins, player2_wins]
  end
end

player1_pos = input[0].split(' starting position: ')[1].to_i
player2_pos = input[1].split(' starting position: ')[1].to_i

puts wins(player1_pos, player2_pos, 0, 0, true, {}).max
