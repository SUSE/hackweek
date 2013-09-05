class Update < ActiveRecord::Base
  validates_presence_of :author_id, :project_id
  
  belongs_to :author, :class_name => User
  belongs_to :project
end
