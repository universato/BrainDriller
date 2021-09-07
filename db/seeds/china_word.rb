require "csv"

module Replace
  def self.double_angle_bracket_to_tag(str)
    return if str.nil?

    bracket = 0
    str.each_char do |c|
      case c
      when "《"
        bracket += 1
        if bracket > 1
          puts "Alert: 《《 #{str[0, 140]}"
        end
      when "》"
        bracket -= 1
        if bracket < 0
          raise ArgumentError, "《》の不一致"
        end
      end
    end

    str.gsub!('《', '<span class="chinese in-statement">')
    str.gsub!('》', '</span>')
    str
  end
end

module DataCheck
  def self.any_empty?(row, *column_names)
    if column_names.any?{ |name| row[name].nil? }
      column_names.find{ row[_1].nil? }
    end
  end
end

first_user = User.find_by(login_name: "uni")
problems = []

drill_titles = [nil, "HSK 1級 中国語単語", "HSK 2級 中国語単語", "HSK 3級 中国語単語"]
drills = drill_titles.map do |title|
  if title
    Drill.find_by(title: title) || Drill.create(title: title, user: first_user, state: "full_open")
  end
end

CSV.foreach('./db/csv/china_word.csv', headers: true).with_index(1) do |row, i|
  if (column_name = DataCheck.any_empty?(row, "hsk_level", "correct", "w1"))
    puts "#{column_name} is empty! Line No.#{i}"
    next
  end

  drill = drills[row["hsk_level"].to_i]

  if row["zero_based_correct_number"].nil?
    puts "Alert: Empty data for zero_based_correct_number column of Line No.#{i}"
  end

  correct_number = row["zero_based_correct_number"].to_i
  choices = [row['w1'], row['w2'], row['w3']].compact
  choices.compact!
  choices.insert(correct_number, row["correct"])

  if choices.size < 2
    puts "choices.size < 2. Line No.#{i} skipped"
    next
  end

  statement = "<span class='chinese big-statement'>#{row['hanyu']}</span>
  <span class='pinyin little-big-statement'>#{row['pinyin']}</span>"

  time = Time.current

  problems << {
    drill_id: drill.id,
    user_id: drill.user.id,
    title: row['title'] || '',
    statement: statement,
    format: "basic_choices",
    choices: choices,
    correct_option: correct_number,
    explanation: Replace.double_angle_bracket_to_tag(row['explanation']) || '',
    created_at: time,
    updated_at: time,
  }
end

Problem.insert_all!(problems)

puts "Done: #{__FILE__} "

# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
