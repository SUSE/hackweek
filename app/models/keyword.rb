class Keyword < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  scope :find_keyword, lambda {
    |str| where('lower(name) like ?', "#{str.downcase}%")
  }

  has_many :project_interests
  has_many :projects, through: :project_interests

  has_many :user_interests
  has_many :users, through: :user_interests
end
