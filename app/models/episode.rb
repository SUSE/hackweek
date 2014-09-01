class Episode < ActiveRecord::Base
  has_and_belongs_to_many :projects

  def active=(state)
    if state == true
      Episode.where("id != ? AND active = ?", self.id, true).each do |episode|
        episode.active = false
        episode.save
      end
    end
    write_attribute(:active, state)
    save
  end
end
