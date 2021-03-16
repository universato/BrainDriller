class Problem < ApplicationRecord
  is_impressionable counter_cache: true

  enum problem_type: {
    basic_choices: 2000,
    simple_choices: 2001
  }
end
