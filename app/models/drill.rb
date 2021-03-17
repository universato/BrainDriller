class Drill < ApplicationRecord
  is_impressionable counter_cache: true
  enum state: { draft: 0, limited_open: 100, full_open: 200 }
end
