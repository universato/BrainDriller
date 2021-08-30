require "csv"

first_user = User.find_by(login_name: "uni")
problems = []

drill_titles = [nil, "HSK 1級 中国語単語", "HSK 2級 中国語単語", "HSK 3級 中国語単語"]
drills = drill_titles.map do |title|
  if title
    Drill.find_by(title: title) || Drill.create(title: title, user: first_user, state: "full_open")
  end
end

CSV.foreach('./db/csv/china_word.csv', headers: true).with_index(1) do |row, i|
  if row["hsk_level"].nil?
    puts "hsk_level is empty! Line No.#{i}"
    next
  end

  drill = drills[row["hsk_level"].to_i]

  choices = [row['correct'], row['w1'], row['w2'], row['w3']].shuffle.compact
  correct_option = choices.find_index{ _1 == row['correct'] }

  if correct_option.nil?
    puts "correct_option is empty! Line No.#{i} skipped"
    next
  end

  if choices.size < 2
    puts "choices.size < 2. Line No.#{i} skipped"
    next
  end

  time = Time.current

  problems << {
    drill_id: drill.id,
    user_id: drill.user.id,
    title: row['title'] || '',
    statement: row['hanyu'] + "\n" + row["pinyin"],
    format: "basic_choices",
    choices: choices,
    correct_option: correct_option,
    explanation: row['explanation'] || '',
    created_at: time,
    updated_at: time,
  }
end

Problem.insert_all!(problems)

puts "#{__FILE__} ended"

# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
