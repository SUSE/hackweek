class Project < ActiveRecord::Base
  attr_accessible :description, :title
  validates :title, :presence => true
  validates :originator_id, :presence => true
  
  belongs_to :originator, :class_name => User
end
