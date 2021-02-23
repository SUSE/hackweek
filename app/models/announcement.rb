class Announcement < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  validates :originator_id, presence: true

  belongs_to :originator, class_name: 'User'
  has_many :enrollments
  has_many :users, through: :enrollments

  def enroll!(user)
    users << user
    save!
  end
end
