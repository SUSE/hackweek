class AddDescriptionToEpisodes < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :description, :text
  end
end
