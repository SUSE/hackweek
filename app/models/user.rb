class User < ActiveRecord::Base
  devise :ichain_authenticatable, :ichain_registerable

  validates :name, :presence => true
  validates :email, :presence => true
  validates_uniqueness_of :name
  validates_uniqueness_of :email

  has_many :originated_projects, :foreign_key => 'originator_id', :class_name => Project
  has_many :updates, :foreign_key => 'author_id', dependent: :destroy

  has_many :memberships
  has_many :comments
  has_many :likes
  has_many :enrollments

  has_many :projects, :through => :memberships
  has_many :announcements, :through => :enrollments
  has_many :favourites, :through => :likes, :source => :project

  has_many :user_interests
  has_many :keywords, :through => :user_interests

  has_and_belongs_to_many :roles

  include Gravtastic
  has_gravatar

  searchable do
    text :name
  end
  
  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  def add_keyword! name
    name.downcase!
    name.gsub! /\s/, "" 
    keyword = Keyword.find_by_name name
    if !keyword
      keyword = Keyword.create! :name => name
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

  def recommended_projects
    if self.keywords.empty?
      return Array.new
    end
    
    projects = []
    self.keywords.each do |word|
      word.projects.each do |p|
        projects << p unless projects.include? p
      end
    end
    projects
  end

  def self.for_ichain_username(username, attributes)
    if user = find_or_create_by(name: username)
      user.update_columns(email: attributes[:email]) if user.email != attributes[:email]
    else
      user = create(name: username, email: attributes[:email])
    end
    user
  end

end
