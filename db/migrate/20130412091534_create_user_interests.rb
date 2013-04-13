class CreateUserInterests < ActiveRecord::Migration
  def change
    create_table :user_interests do |t|
      t.integer :user_id
      t.integer :keyword_id

      t.timestamps
    end
  end
end
