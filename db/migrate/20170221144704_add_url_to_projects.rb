class AddUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :url, :string
    Project.initialize_urls
  end
end
