class Invitation < ApplicationRecord
  has_many :coaches
  has_many :users
end
