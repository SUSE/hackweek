class ProjectBelongToEvents < ActiveRecord::Migration
  def self.up
    create_table :events_projects, :id => false do |t|
      t.references :event, :project
    end
  end

  def self.down
    drop_table :events_projects
  end
end
