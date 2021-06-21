class Problem < ApplicationRecord
  is_impressionable counter_cache: true
  has_many :user_problem_relations

  belongs_to :drill
  belongs_to :user

  enum format: {
    basic_choices: 2000,
    simple_choices: 2001
  }
end
