class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :text
      t.integer :originator_id

      t.timestamps
    end
  end
end
