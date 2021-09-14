# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
require "csv"
require "json"

unless Rails.env.development?
  puts "developmentでないため、終了します。"
  exit
end

first_user = User.first

KAMOKUS = {
  "kigyo" => "企業法",
  "kansa" => "監査論",
  "kanri" => "管理会計",
  "zaimu" => "財務会計",
}

problems = []
CSV.foreach('db/csv/cpa_aiueo_problems.csv', headers: true).with_index do |row, _i|
  next if row['kamoku'] == "kansa"

  drill_title = KAMOKUS[row['kamoku']]
  drill = Drill.find_by(title: drill_title)
  drill ||= Drill.create!(title: drill_title, user: first_user)

  user = drill.user
  time = Time.current

  problems << {
    drill_id: drill.id,
    user_id: user.id,
    title: row['id'],
    statement: row['statement'],
    format: "basic_choices",
    choices: ["正", "誤"],
    correct_option: row['correct_option'].to_i,
    explanation: row['explanation'] || '',
    created_at: time,
    updated_at: time,
  }
end

Problem.insert_all!(problems)

puts "Done: #{problems.size} files, #{__FILE__}"
