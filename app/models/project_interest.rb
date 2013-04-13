class ProjectInterest < ActiveRecord::Base
  attr_accessible :keyword_id, :project_id
  
  belongs_to :project
  belongs_to :keyword
end
