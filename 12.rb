require 'set'

input = File.read('12.input').split("\n").map(&:strip)

# problem 1

graph = {}
input.each do |line|
  from, to = line.split('-')
  graph[from] ||= []
  graph[from].push(to) if to != 'start'
  graph[to] ||= []
  graph[to].push(from) if from != 'start'
end

def count_ways(graph, node, visited = [])
  return 1 if node == 'end'

  paths = graph[node] - visited
  return 0 if paths.empty?

  if node[0] >= 'a' && node[0] <= 'z'
    visited = visited + [node]
  end

  paths.map do |next_node|
    count_ways(graph, next_node, visited)
  end.sum
end

puts count_ways(graph, 'start')

# problem 2

def count_ways2(graph, node, visited = [], can_visit_again = true)
  return 1 if node == 'end'

  if visited.include?(node)
    if can_visit_again
      can_visit_again = false
    else
      return 0
    end
  end

  if node[0] >= 'a' && node[0] <= 'z' && !visited.include?(node)
    visited = visited + [node]
  end

  graph[node].map do |next_node|
    count_ways2(graph, next_node, visited, can_visit_again)
  end.sum
end

puts count_ways2(graph, 'start')

