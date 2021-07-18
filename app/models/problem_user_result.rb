class ProblemUserResult < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  validates :user_id,    presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :problem_id, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # 問題の閲覧回数
  # 問題の回答回数
  # 問題の正解回数
  # 問題のカラム名と統一させたい。
  validates :number_of_views, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :number_of_submissions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :number_of_correct_answers, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
