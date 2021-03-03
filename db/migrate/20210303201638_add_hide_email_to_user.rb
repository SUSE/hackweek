class AddHideEmailToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hide_email, :boolean, default: false
  end
end
