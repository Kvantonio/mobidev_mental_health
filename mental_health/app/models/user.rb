class User < ApplicationRecord
  enum gender: [:male, :female]

  has_secure_password

  validates :name, presence: true
  validates :password,
            presence: true,
            format: { with: /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/ },
            allow_nil: true
  validates :email, presence: true, uniqueness: true,
            format: { with: /^.+@.+$/ }
  validates :age, presence: false
  validates :abouts, presence: false
  validates :gender, presence: false
end
