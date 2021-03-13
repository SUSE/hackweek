class Keyword < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  scope :find_keyword, lambda { |str|
    where('lower(name) like ?', "#{str.downcase}%")
  }

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :users
end
