class Like < ApplicationRecord
  belongs_to :project, counter_cache: true
  belongs_to :user
end
