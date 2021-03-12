class AddAvatarToKeywords < ActiveRecord::Migration[5.2]
  def up
    add_attachment :keywords, :avatar
  end

  def down
    remove_attachment :keywords, :avatar
  end
end
