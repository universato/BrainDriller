user = User.first

if user.nil?
  pust "ユーザーが0により終了。seeds/drills.rb line_no:#{__LINE__}"
  exit
end

puts "環境:"
puts Rails.env

ruby_user = User.find_by!(login_name: "ruby")
ruby_drill = Drill.find_or_create_by!(
  user: ruby_user,
  title: "Ruby入門",
  guide: "Rubyの基本的な問題を扱っています。",
  state: "full_open",
)

statement = <<~MARKDOWN
`[1, 2, 3].map{ |e| e * 2 }`は何を返しますか
MARKDOWN
choices = [
  "[1, 2, 3]",
  "[2, 4, 6]",
  "[3, 6, 9]",
  "[1, 2, 3, 4, 5, 6]"
]
correct_option = 1
explanation = ""
ruby_drill.problems.create!(
  user: ruby_user,
  title: "Rubyの問題",
  statement: statement,
  explanation: explanation,
  format: "basic_choices",
  choices: choices,
  correct_option: correct_option,
)

puts "正常にruby_drillの問題が追加されました。作られた？"
