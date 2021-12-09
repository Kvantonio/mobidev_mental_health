class User < ApplicationRecord
  enum gender: [ :male, :female ], _prefix: :gender

  has_secure_password

  validates :name, presence: true
  validates :password,
            presence: true,
            format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}\z/ },
            allow_nil: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A.+@.+\..+\z/ }
  validates :age, presence: false
  validates :abouts, presence: false
  validates :gender, presence: false

  has_and_belongs_to_many :problems

  has_one :invitation
  has_many :coches, through: :invitations

  has_many :user_notifications

  has_many :ratings
  has_many :recommendations

  has_one_attached :user_avatar
end
