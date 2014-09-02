class EpisodesProjects < ActiveRecord::Base
  belongs_to :project
  belongs_to :episode
end
