class RenameEventsToEpisode < ActiveRecord::Migration[4.2]
  def change
    rename_table :events, :episodes
    rename_column :events_projects, :event_id, :episode_id
    rename_table :events_projects, :episodes_projects
  end
end
