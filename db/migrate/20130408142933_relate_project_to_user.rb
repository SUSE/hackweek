class RelateProjectToUser < ActiveRecord::Migration
  def up
    add_column :projects, :originator_id, :integer
    remove_column :projects, :name
  end

  def down
    add_column :projects, :name, :string
    remove_column :projects, :orginator_id
  end
end
