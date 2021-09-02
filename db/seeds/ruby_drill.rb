require "csv"

module ProblemMaker
  def self.make_choices(correct_option, zero_based_correct_number, *wrong_options, line_no:)
    if correct_option.nil? || wrong_options.compact.size.zero? || zero_based_correct_number&.negative?
      raise ArgumentError, "correct_options, wrong_options or correct_number is not valid. Line No. #{line_no}"
    end

    nil_flag = false
    wrong_options.each do |option|
      if nil_flag && option
        raise ArgumentError, "途中にnilが挟まっていた. Line No. #{line_no}"
      elsif option.nil?
        nil_flag = true
      end
    end

    wrong_options.compact!
    if wrong_options.size < zero_based_correct_number
      raise ArgumentError, "正解番号がでかいか  Line No. #{line_no}"
    end

    wrong_options.insert(zero_based_correct_number, correct_option)
  end
end
# p ProblemMaker.make_choices("c", 0, "w1", "w2", "w3", line_no: 99)
# p ProblemMaker.make_choices("c", 1, "w1", "w2", "w3", line_no: 100)
# p ProblemMaker.make_choices("c", 2, "w1", "w2", "w3", line_no: 101)
# p ProblemMaker.make_choices("c", 3, "w1", "w2", "w3", line_no: 102)
# p ProblemMaker.make_choices("o", 1, "x", line_no: 103)

first_user = User.first
drills_by_title = {}
problems = []
CSV.foreach('./db/csv/ruby.csv', headers: true).with_index(1) do |row, line_no|
  drill_title = row['drill_title']
  if drill_title.nil?
    puts "#{line_no}行目のdrill_titleがないため、飛ばしました"
    next
  elsif drills_by_title[drill_title].nil?
    drill = Drill.find_by(title: drill_title)
    drill ||= Drill.create(title: row['drill_title'], user: first_user, state: "full_open")
    drills_by_title[drill_title] = drill
  else
    drill = drills_by_title[drill_title]
  end

  user = drill.user

  choices = ProblemMaker.make_choices(
    row["correct_option"],
    row["zero_based_ans"].to_i,
    row['w1'], row['w2'], row['w3'],
    line_no: line_no,
  )

  time = Time.current

  problems << {
    drill_id: drill.id,
    user_id: user.id,
    title: row['title'] || '',
    statement: row['statement'],
    format: "basic_choices",
    choices: choices,
    correct_option: row["zero_based_ans"].to_i,
    explanation: row['explanation'] || '',
    created_at: time,
    updated_at: time,
  }
end

Problem.insert_all!(problems)

__END__

# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita
# https://qiita.com/kumasuke/items/545afaf5876d3dc52670
