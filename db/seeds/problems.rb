# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
require "csv"

Problem.destroy_all
first_user = User.first

CSV.foreach('./db/csv/problems.csv', headers: true) do |row|
  drill = Drill.find_by(title: row['drill_title'])
  drill ||= Drill.create(title: row['drill_title'], user: first_user)

  user = drill.user

  Problem.create!(
    drill: drill,
    user: user,
    title: row['title'] || '',
    statement: row['statement'],
    format: "basic_choices",
    choices: [row['o1'], row['o2'], row['o3'], row['o4']],
    correct_option: row['ans'].to_i - 1,
    in_order: row['in_order'],
    explanation: row['explanation'] || '',
    questioner: 1,
  )
end
