class Technique < ApplicationRecord
  enum gender: [:male, :female, :both]

  has_many :steps
  has_and_belongs_to_many :problems

  has_many :ratings
  has_many :recommendations
  has_one_attached :image
end
