Drill.all.each do |drill|
  problem_size = drill.problems.size
  drill.update(problem_size: problem_size)
end
