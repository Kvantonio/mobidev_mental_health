class Recommendation < ApplicationRecord
  belongs_to :coach
  belongs_to :user
  belongs_to :technique

  validates :started_at, presence: false
  validates :finished_at, presence: false
  validates :current_step, presence: false
end
