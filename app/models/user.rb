class User < ApplicationRecord
  devise :ichain_authenticatable, :ichain_registerable

  validates :name, presence: true
  validates :email, presence: true
  validates_uniqueness_of :name
  validates_uniqueness_of :email

  has_many :originated_projects, foreign_key: 'originator_id', class_name: 'Project'
  has_many :updates, foreign_key: 'author_id', dependent: :destroy

  has_many :memberships
  has_many :comments, foreign_key: 'commenter_id'
  has_many :likes
  has_many :enrollments

  has_many :projects, through: :memberships
  has_many :announcements, through: :enrollments
  has_many :favourites, through: :likes, source: :project

  has_many :user_interests
  has_many :keywords, through: :user_interests

  has_many :project_follows
  has_many :project_followings, through: :project_follows, source: :project

  has_many :notifications, foreign_key: :recipient_id

  has_and_belongs_to_many :roles

  after_save ThinkingSphinx::RealTime.callback_for(:user)

  include Gravtastic
  has_gravatar

  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  def to_param
    name
  end

  def add_keyword! name
    name.downcase!
    name.gsub!(/\s/, '')
    keyword = Keyword.find_by_name name
    if !keyword
      keyword = Keyword.create! name: name
    end
    if !self.keywords.include? keyword
      self.keywords << keyword
      save!
    end
  end

  def remove_keyword! name
    keyword = Keyword.find_by_name name
    if self.keywords.include? keyword
      self.keywords.delete(keyword)
      save!
    end
  end

  def recommended_projects(episode = nil)
    if self.keywords.empty?
      return []
    end

    recommended = []
    self.keywords.each do |word|
      if episode
        projects = word.projects.select { |p| p.episodes.include?(episode)  }
      else
        projects = word.projects
      end
      projects.each do |p|
        next unless p.active?
        if episode
          recommended << p if p.episodes.include?(episode)
        else
          recommended << p
        end
      end
    end
    recommended.uniq
  end

  def self.for_ichain_username(username, attributes)
    attributes = attributes.with_indifferent_access
    user = find_by(name: username)
    if user
      user.update_attributes(email: attributes[:email]) if user.email != attributes[:email]
    else
      user = create(name: username, email: attributes[:email])
    end
    user
  end
end
