# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
require "csv"
require "json"

unless Rails.env == 'development'
  puts "developmentでないため、終了します。"
  exit
end

first_user = User.first

CSV.foreach('db/csv/cpa.csv', headers: true).with_index do |row, _i|
  drill_title = row['title'].sub(/-.\d+/, '')
  drill = Drill.find_by(title: drill_title)
  drill ||= Drill.create!(title: drill_title, user: first_user)

  user = drill.user

  Problem.create!(
    drill: drill,
    user: user,
    title: row['title'],
    statement: row['statement'],
    format: "basic_choices",
    choices: %w[アイ アウ アエ イウ イエ ウエ],
    correct_option: row['ans'].to_i - 1,
    explanation: row['explanation'] || '',
    # open: true
  )
end

# puts "#{__FILE__}が実行された"
