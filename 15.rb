require 'set'

input = File.read('15.input').split("\n").map(&:strip)

# Problem 1

def build_dag(arr)
  dag = {}

  arr.each.with_index do |line, y|
    dag[y] ||= {}

    line.each.with_index do |c, x|
      dag[y][x] = []

      neighbors = [
        [x + 1, y],
        [x, y + 1],
        [x - 1, y],
        [x, y - 1]
      ].each do |coords|
        new_x, new_y = coords

        if new_x >= 0 && new_y >= 0 && new_x < arr.count && new_y < arr.count
          dag[y][x].push([new_x, new_y, arr[new_y][new_x]])
        end
      end
    end
  end

  dag
end

def start_search(arr)
  dag = build_dag(arr)

  visited = Set.new
  start = [0, 0]
  queue = [start]
  queued = Set.new
  queued.add("#{start[0]},#{start[1]}")

  path_costs = { 0 => { 0 => 0 } }
  path_costs_w_distance = { 0 => { 0 => 0 } }

  while true
    pos = nil
    min_cost = nil
    queue.each do |node|
      x, y = node

      path_costs_w_distance[y] ||= {}
      path_distance_cost = path_costs_w_distance[y][x] || 0

      if min_cost.nil? || min_cost > path_distance_cost
        pos = node
        min_cost = path_distance_cost
      end
    end

    queue = queue - [pos]

    x, y = pos

    path_costs[y] ||= {}
    path_cost = path_costs[y][x] || 0

    visited.add("#{x},#{y}")

    dag[y][x].each do |connection|
      new_x, new_y, cost = connection

      new_path_cost = path_cost + cost

      if new_x == arr.count - 1 && new_y == arr.count - 1
        return new_path_cost
      end

      if !visited.include?("#{new_x},#{new_y}")
        distance = arr.count - 1 - new_x + arr.count - 1 - new_y
        new_path_cost_w_distance = new_path_cost + distance

        if queued.include?("#{new_x},#{new_y}")
          path_costs[new_y][new_x] = [path_costs[new_y][new_x], new_path_cost].min
          path_costs_w_distance[new_y][new_x] = [path_costs_w_distance[new_y][new_x], new_path_cost_w_distance].min
        else
          queued.add("#{new_x},#{new_y}")
          queue.push([new_x, new_y])
          path_costs[new_y] ||= {}
          path_costs[new_y][new_x] = new_path_cost
          path_costs_w_distance[new_y] ||= {}
          path_costs_w_distance[new_y][new_x] = new_path_cost_w_distance
        end
      end
    end
  end
end

arr = input.map { |l| l.chars.map(&:to_i) }

puts start_search(arr)

# problem 2

arr = input.map { |l| l.chars.map(&:to_i) }
new_arr = Array.new(arr.count * 5).map { Array.new(arr.count * 5, 0) }

arr.each.with_index do |line, y|
  line.each.with_index do |c, x|
    (0...5).each do |i_y|
      (0...5).each do |i_x|
        new_c = ((c + i_y + i_x - 1) % 9) + 1
        new_arr[y + i_y * arr.count][x + i_x * arr.count] = new_c
      end
    end
  end
end

arr = new_arr

puts start_search(arr)
