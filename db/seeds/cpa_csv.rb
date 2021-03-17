# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita https://qiita.com/kumasuke/items/545afaf5876d3dc52670
require "csv"
require "json"

unless Rails.env == 'development'
  puts "developmentでないため、終了します。"
  exit
end

# Problem.destroy_all
# puts "削除した!?"


SEED_FOR_PROBLEM = 10 ** 9 + 7 # 1_000_000_007 is a prime number
number_of_user = 1000
i = 300
CSV.foreach('db/csv/cpa.csv', headers: true) do |row|
  i += 1
  random_variable = SEED_FOR_PROBLEM * i
  random_views = random_variable % number_of_user
  random_submissions =  (0 == random_views ? 0 : random_variable % random_views)
  random_correct_answer = (0 == random_submissions ? 0 : random_variable % random_submissions )
  correct_answer_rate = ( 0 == random_submissions ? nil :  100 * random_correct_answer / random_submissions)

  title = row['title'].sub(/-.\d+/, '')
  d = Drill.find_or_create_by(title: title, user_id: 1)

  @problem = Problem.create!(
    problem_type: :basic_choices,
    title: row['title'],
    statement: row['statement'],
    choices: %w[アイ アウ アエ イウ イエ ウエ],
    # correct_option_number: row['ans'],
    in_order: row['in_order'],
    explanation: row['explanation'] || '',
    questioner: 1,

    number_of_views: random_views,
    number_of_submissions: random_submissions,
    number_of_correct_answers: random_correct_answer,
    correct_answer_rate: correct_answer_rate,
    correct_people_rate: correct_answer_rate,
    open: true
  )
  # tag_list = [row['tag0'], row['tag1'], row['tag2']]
  # @problem.save_tags(tag_list)
end
