class AddProjecthitsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :projecthits, :integer, default: 0
  end
end
