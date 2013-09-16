class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :originated_projects, :foreign_key => 'originator_id', :class_name => Project
  has_many :updates, :foreign_key => 'author_id'
  
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

end
