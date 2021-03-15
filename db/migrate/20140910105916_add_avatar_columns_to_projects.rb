class AddAvatarColumnsToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_attachment :projects, :avatar
  end

  def self.down
    remove_attachment :projects, :avatar
  end
end
