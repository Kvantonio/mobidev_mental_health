class Invitation < ApplicationRecord
  belongs_to :coach
  belongs_to :user
end
