class CreateProjectFollows < ActiveRecord::Migration[4.2]
  def change
    create_table :project_follows do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
