class Keyword < ActiveRecord::Base
  attr_accessible :name
  
  has_many :project_interests
  has_many :projects, :through => :project_interests

  has_many :user_interests
  has_many :users, :through => :user_interests
end
