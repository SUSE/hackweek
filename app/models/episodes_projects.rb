class EpisodesProjects < ApplicationRecord
  belongs_to :project
  belongs_to :episode
end
