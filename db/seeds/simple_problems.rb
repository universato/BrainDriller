first_user = User.first

problems = File.read("db/simple_problems/english.txt").split("\n\n")

header = problems.shift.split
drill_title, guide = header[0]

drill = Drill.find_by(title: drill_title)
drill ||= Drill.create!(
  title: drill_title,
  user: first_user,
  guide: guide || '',
)

unless drill.problems.empty?
  puts "作成済みのドリルの問題が空でなかったため、問題の作成を中止します。"
  exit
end

user = drill.user

problems.each do |problem|
  statement, o1, o2, o3, o4, correct_option, explanation = problem.split("\n")
  Problem.create(
    drill: drill,
    user: user,
    title: '',
    statement: statement,
    format: "basic_choices",
    choices: [o1, o2, o3, o4],
    correct_option: correct_option.to_i - 1,
    explanation: explanation || '',
  )
end
