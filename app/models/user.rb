class User < ActiveRecord::Base
  attr_accessible :email, :name, :uid
  
  has_many :originated_projects, :foreign_key => 'originator_id', :class_name => Project
  has_many :updates, :foreign_key => 'author_id'
  
  has_many :memberships
  has_many :projects, :through => :memberships
  
  has_many :comments
  
  include Gravtastic
  has_gravatar
end
