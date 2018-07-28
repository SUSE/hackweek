class AddNotifiedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notified, :boolean, default: true
  end
end
