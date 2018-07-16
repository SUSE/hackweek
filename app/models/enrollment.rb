class Enrollment < ApplicationRecord
  belongs_to :announcement
  belongs_to :user
end
