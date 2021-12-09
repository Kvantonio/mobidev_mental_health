class CoachNotification < ApplicationRecord
  belongs_to :coach
  belongs_to :user, optional: true
end
