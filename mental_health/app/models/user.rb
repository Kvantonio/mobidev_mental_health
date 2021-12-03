class User < ApplicationRecord
  enum gender: [ :male, :female ], _prefix: :gender

  has_secure_password

  validates :name, presence: true
  validates :password,
            presence: true,
            format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}\z/ },
            allow_nil: true
  validates :email, presence: true, uniqueness: true,
            format: { with: /\A.+@.+\z/ }
  validates :age, presence: false
  validates :abouts, presence: false
  validates :gender, presence: false

  has_and_belongs_to_many :problems

  has_many :invitations
  has_many :coches, through: :invitations

  has_many :notifications

  has_many :ratings
end
