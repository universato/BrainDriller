class Drill < ApplicationRecord
  is_impressionable counter_cache: true
  enum state: { draft: 0, limited_open: 100, full_open: 200 }
  belongs_to :user
  has_many :problems
  has_many :drill_likes, dependent: :destroy

  validates :title, presence: true, length: { in: 1..32 }
  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :title }
  validates :state, presence: true
end
