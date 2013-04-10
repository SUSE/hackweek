class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :commenter_id

      t.timestamps
    end
  end
end
