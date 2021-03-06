require "csv"

__END__

first_user = User.first
problems = []
CSV.foreach('./db/csv/problems.csv', headers: true).with_index(1) do |row, i|
  drill = Drill.find_by(title: row['drill_title'])
  drill ||= Drill.create(title: row['drill_title'], user: first_user, state: "full_open")

  user = drill.user

  o1, o2, o3, o4 = row['o1'], row['o2'], row['o3'], row['o4']
  if row['statement'].nil? || row['ans'].nil?
    puts "#{i}行目の問題文か正解がないため、飛ばしました"
    next
  elsif o1.nil? && o2.nil? && o3.nil? && o4.nil?
    puts "#{i}行目の選択肢が全て空欄であるため、飛ばしました"
    next
  elsif o1 == o2 || o1 == o3 || o1 == o4 || o2 == o3 || o3 == o4
    puts "選択肢が同じものが検出されました. #{i}行目の#{(row['statement'] || '')[0, 100]}"
    p [o1, o2, o3, o4]
    exit
  end

  if o1.nil? || o2.nil? || o3.nil? || o4.nil?
    puts "#{i}行目の選択肢に空欄があります。"
  end

  time = Time.current

  problems << {
    drill_id: drill.id,
    user_id: user.id,
    title: row['title'] || '',
    statement: row['statement'],
    format: "basic_choices",
    choices: [o1, o2, o3, o4],
    correct_option: row['ans'].to_i - 1,
    explanation: row['explanation'] || '',
    created_at: time,
    updated_at: time,
  }
end

Problem.insert_all!(problems)

__END__

# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670

# Before 3.13s
# After 0.7099
