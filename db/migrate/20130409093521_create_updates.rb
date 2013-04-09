class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.text :text
      t.integer :author_id
      t.integer :project_id

      t.timestamps
    end
  end
end
