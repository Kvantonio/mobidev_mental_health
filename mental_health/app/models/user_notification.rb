class UserNotification < ApplicationRecord
  belongs_to :coach, optional: true
  belongs_to :user
end
