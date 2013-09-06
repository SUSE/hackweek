class AddProjectCounterCache < ActiveRecord::Migration
  def up
    add_column :projects, :likes_count, :integer
    add_column :projects, :memberships_count, :integer
  end

  def down
    remove_column :projects, :likes_count
    remove_column :projects, :memberships_count
  end

end
