class AddLocationToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :location, :string
  end
end
