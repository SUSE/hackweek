class Update < ActiveRecord::Base
  attr_accessible :author_id, :author, :project_id, :project, :text

  validates_presence_of :author_id, :project_id
  
  belongs_to :author, :class_name => User
  belongs_to :project
end
