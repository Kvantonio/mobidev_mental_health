class Coach < ApplicationRecord
  enum gender: [:male, :female], _prefix: :gender

  has_secure_password

  validates :password,
            presence: true,
            format: { with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/ },
            allow_nil: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A.+@.+\..+\z/ }
  validates :age, presence: false
  validates :abouts, presence: false
  validates :gender, presence: false

  has_many :experiences
  has_many :certificates
  has_many :diplomas
  has_many :social_networks
  has_and_belongs_to_many :problems

  has_many :invitations
  has_many :users, through: :invitations

  has_many :coach_notifications
  has_many :recommendations

  has_one_attached :coach_avatar
end
