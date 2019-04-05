class Announcement < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  validates :originator_id, presence: true

  belongs_to :originator, class_name: 'User'
  has_many :enrollments
  has_many :users, through: :enrollments

  def enroll! user
    self.users << user
    self.save!
  end
end
