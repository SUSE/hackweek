class CreateProjectInterests < ActiveRecord::Migration[4.2]
  def change
    create_table :project_interests do |t|
      t.integer :project_id
      t.integer :keyword_id

      t.timestamps
    end
  end
end
