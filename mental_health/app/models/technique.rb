class Technique < ApplicationRecord
  enum gender: [:male, :female]

  has_many :steps
  has_and_belongs_to_many :problems

  has_many :ratings
end
