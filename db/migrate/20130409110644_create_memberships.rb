class CreateMemberships < ActiveRecord::Migration[4.2]
  def change
    create_table :memberships do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
