class RenameUserInterest < ActiveRecord::Migration[5.2]
  def change
    rename_table('user_interests', 'keywords_users')
  end
end
