# 【Rails】rake seedコマンドでCSVファイルからDBに読み込ませる方法 - Qiita https://qiita.com/kumasuke/items/545afaf5876d3dc52670
require "csv"

Problem.destroy_all
# Tag.destroy_all
ProblemTagging.destroy_all
# Problem::ProblemTagging.destroy_all
# Tag.destroy_all
SEED_FOR_PROBLEM = 10 ** 9 + 7 # 1_000_000_007 is a prime number
number_of_user = 100
i = 300
CSV.foreach('./db/csv/problems.csv', headers: true) do |row|
# CSV.foreach('db/csv/problems.csv', headers: true) do |row|
  i += 1
  random_variable = SEED_FOR_PROBLEM * i
  random_views = random_variable % number_of_user
  random_submissions =  (0 == random_views ? 0 : random_variable % random_views)
  random_correct_answer = (0 == random_submissions ? 0 : random_variable % random_submissions )
  correct_answer_rate = ( 0 == random_submissions ? nil :  100 * random_correct_answer / random_submissions)
  @problem = Problem.create!(
    title: row['title'],
    statement: row['statement'],
    option0: row['o1'],
    option1: row['o2'],
    option2: row['o3'],
    option3: row['o4'],
    correct_option_number: row['ans'],
    in_order: row['in_order'],
    # tag0: row['tag0'],
    # tag1: row['tag1'],
    # tag2: row['tag2'],
    explanation: row['explanation'],
    questioner: 1,

    number_of_views: random_views,
    number_of_submissions: random_submissions,
    number_of_correct_answers: random_correct_answer,
    correct_answer_rate: correct_answer_rate,
    open: true
  )
  tag_list = [row['tag0'], row['tag1'], row['tag2']]
  # @problem.save_tags(tag_list)
end

require_relative "./cpa_csv"

# SEED_FOR_PROBLEM = 10 ** 9 + 7 # 1_000_000_007 is a prime number
# number_of_user = 100

exit

99.times do |i|
  random_variable = SEED_FOR_PROBLEM * i
  random_views = random_variable % number_of_user
  random_submissions =  (0 == random_views ? 0 : random_variable % random_views)
  random_correct_answer = (0 == random_submissions ? 0 : random_variable % random_submissions )
  correct_answer_rate = ( 0 == random_submissions ? nil :  100 * random_correct_answer / random_submissions)
  Problem.create!(
              title: "無題#{i+1}",
              statement:  "問題文#{i+1}:",
              correct1: "seikai#{i+1}",
              incorrect1: "huseikai1",
              incorrect2: "huseikai2",
              incorrect3: "huseikai2",

              option0: "選択肢0",
              option1: "選択肢1",
              option2: "選択肢2",
              option3: "選択肢3",
              correct_option_number: 1,

              number_of_views: random_views,
              number_of_submissions: random_submissions,
              number_of_correct_answers: random_correct_answer,
              correct_answer_rate: correct_answer_rate,

              questioner: 1,
              open: true
              )
end

@problem = Problem.create!(
  title: "山",
  statement: "日本一高い山は",
  correct1: "富士山",
  incorrect1: "エベレスト",
  incorrect2: "阿蘇山",
  incorrect3: "信濃川",

  option0: "富士山",
  option1: "エベレスト",
  option2: "阿蘇山",
  option3: "信濃川",
  correct_option_number: 1,

  tag0: "山",
  tag1: "常識",
  tag2: "簡単",

  number_of_views: 200,
  number_of_submissions: 50,
  number_of_correct_answers: 49,
  correct_answer_rate: 100 * 49 / 50,
  questioner: 1,
  open: true
)
# @problem.save_tags(["山", "常識", "簡単"])
