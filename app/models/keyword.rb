class Keyword < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  scope :find_keyword, lambda { |str|
    where('lower(name) like ?', "#{str.downcase}%")
  }

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :users

  has_attached_file :avatar, styles: { thumb: '150x150#' }
  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\Z}

  scope :by_episode, lambda { |episode|
    joins(:keywords_projects).where(keywords_projects: { project: episode.projects.pluck(:id) }) if episode && episode.is_a?(Episode)
  }
end
