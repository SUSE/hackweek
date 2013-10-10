class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :announcement_id
      t.integer :user_id

      t.timestamps
    end
  end
end
