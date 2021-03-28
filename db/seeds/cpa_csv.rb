# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
require "csv"
require "json"

unless Rails.env == 'development'
  puts "developmentでないため、終了します。"
  exit
end

first_user = User.first

CSV.foreach('db/csv/cpa.csv', headers: true) do |row|
  drill_title = row['title'].sub(/-.\d+/, '')
  drill = Drill.find_by(title: drill_title)
  drill ||= Drill.create(title: drill_title, user: first_user)

  user = drill.user

  @problem = Problem.create!(
    drill: drill,
    user: user,
    format: :basic_choices,
    title: row['title'],
    statement: row['statement'],
    choices: %w[アイ アウ アエ イウ イエ ウエ],
    correct_option: row['ans'].to_i - 1,
    explanation: row['explanation'] || '',
    questioner: 1,
    open: true
  )
end
