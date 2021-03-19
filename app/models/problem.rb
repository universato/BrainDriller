class Problem < ApplicationRecord
  is_impressionable counter_cache: true

  belongs_to :drill
  belongs_to :user

  enum format: {
    basic_choices: 2000,
    simple_choices: 2001
  }
end
