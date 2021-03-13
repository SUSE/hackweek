class RenameMemberships < ActiveRecord::Migration[5.2]
  def change
    rename_table('memberships', 'projects_users')
  end
end
