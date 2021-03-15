class ProjectBelongToEvents < ActiveRecord::Migration[4.2]
  def self.up
    create_table :events_projects, id: false do |t|
      t.references :event, :project
    end
  end

  def self.down
    drop_table :events_projects
  end
end
