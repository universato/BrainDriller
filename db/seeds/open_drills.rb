Drill.all.each do |drill|
  if drill.problems.size.zero?
    drill.state = :draft
  else
    drill.state = :full_open
  end
  drill.save!
end
