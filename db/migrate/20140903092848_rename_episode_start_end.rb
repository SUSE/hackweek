class RenameEpisodeStartEnd < ActiveRecord::Migration
  def change
    rename_column :episodes, :start, :start_date
    rename_column :episodes, :end, :end_date
  end
end
