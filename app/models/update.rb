class Update < ApplicationRecord
  validates_presence_of :author_id, :project_id
  validates :text, length: { maximum: 10_000 }

  belongs_to :author, class_name: 'User'
  belongs_to :project
end
