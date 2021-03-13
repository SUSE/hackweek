class Episode < ApplicationRecord
  has_and_belongs_to_many :projects

  validates :name, presence: true

  def self.active
    Episode.where(active: true).first
  end

  def active=(state)
    if state == true
      Episode.where('id != ? AND active = ?', id, true).each do |episode|
        episode.active = false
        episode.save
      end
    end
    write_attribute(:active, state)
    save
  end
end
