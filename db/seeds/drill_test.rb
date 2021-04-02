user = User.first

if user.nil?
  pust "ユーザーが0により終了。seeds/drills.rb line_no:#{__LINE__}"
  exit
end

puts "環境:"
puts Rails.env

# drill = Drill.where(title: 'test', ser: user)[0]
drill = Drill.find_by(title: 'test')
drill ||= user.drills.create(title: 'test', user: user, guide: "ガイド https://github.com", state: "full_open")

Problem.create!(
  drill: drill,
  user: user,
  title: 'link test',
  statement: "st https://github.com",
  format: "basic_choices",
  choices: ["s1 https://github.com", "s2 https://github.com"],
  correct_option: 0,
  in_order: true,
  explanation: 'ex https://github.com',
)
