class RenameMembershipsBack < ActiveRecord::Migration[5.2]
  def change
    rename_table(:projects_users, :memberships)
  end
end
