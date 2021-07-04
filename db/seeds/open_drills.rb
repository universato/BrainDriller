Drill.all.each do |drill|
  drill.state = :full_open
  drill.save!
end
