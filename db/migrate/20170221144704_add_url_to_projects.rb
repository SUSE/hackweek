class AddUrlToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :url, :string
    Project.initialize_urls
  end
end
