class Problem < ApplicationRecord
  is_impressionable counter_cache: true
  has_many :problem_user_results

  belongs_to :drill
  belongs_to :user

  enum format: {
    basic_choices: 2000,
    simple_choices: 2001
  }

  def correct_answer
    self.choices[self.correct_option]
  end
end
