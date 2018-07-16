class Episode < ApplicationRecord

  has_many :episode_project_associations
  has_many :projects, through: :episode_project_associations

  validates :name, presence: true

  def self.active
    Episode.where(active: true).first
  end

  def active=(state)
    if state == true
      Episode.where('id != ? AND active = ?', self.id, true).each do |episode|
        episode.active = false
        episode.save
      end
    end
    write_attribute(:active, state)
    save
  end
end
