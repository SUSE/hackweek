class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
