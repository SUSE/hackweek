class User < ActiveRecord::Base
  devise :ichain_authenticatable, :ichain_registerable
  has_many :originated_projects, :foreign_key => 'originator_id', :class_name => Project
  has_many :updates, :foreign_key => 'author_id', dependent: :destroy

  has_many :memberships
  has_many :comments
  has_many :likes

  has_many :projects, :through => :memberships
  has_many :favourites, :through => :likes, :source => :project

  has_many :user_interests
  has_many :keywords, :through => :user_interests

  include Gravtastic
  has_gravatar
  
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
    
    self.keywords.last.projects
  end

  def self.for_ichain_username(username, attributes)
    if user = find_or_create_by(name: username)
      update_all({:email => attributes[:email]}, {:id => user.id}) if user.email != attributes[:email]
    else
      user = create(nickname: username, email: attributes[:email])
    end
    user
  end

end
