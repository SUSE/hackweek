class AddAvatarColumnsToProjects < ActiveRecord::Migration
  def self.up
    add_attachment :projects, :avatar
  end

  def self.down
    remove_attachment :projects, :avatar
  end
end
