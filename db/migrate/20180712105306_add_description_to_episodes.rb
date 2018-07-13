class AddDescriptionToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :description, :text
  end
end
