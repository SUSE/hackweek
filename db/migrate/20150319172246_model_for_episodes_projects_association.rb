class ModelForEpisodesProjectsAssociation < ActiveRecord::Migration
  def change
    add_column :episodes_projects, :id, :primary_key
    add_column :episodes_projects, :created_at, :datetime

    # We will be ordering this field to populate RSS feed
    add_index :episodes_projects, :created_at

    # To make sure every association is there only once
    add_index :episodes_projects, [:episode_id, :project_id], unique: true

    # Composite index [A, B] can be used in searches for only A, but not for only B
    add_index :episodes_projects, :project_id
  end
end
