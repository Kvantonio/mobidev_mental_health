class Notification < ApplicationRecord
  belongs_to :coach, optional: true
  belongs_to :user, optional: true
end
