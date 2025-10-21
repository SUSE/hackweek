class AddHamToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :ham, :boolean, default: false, null: false
  end
end
