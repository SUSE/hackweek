class AddDescriptionToKeywords < ActiveRecord::Migration[5.2]
  def change
    add_column :keywords, :description, :string
  end
end
