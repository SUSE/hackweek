class RenameProjectInterest < ActiveRecord::Migration[5.2]
  def change
    rename_table('project_interests', 'keywords_projects')
  end
end
