class AddAasmState < ActiveRecord::Migration[4.2]
  def up
    add_column :projects, :aasm_state, :string
  end

  def down
    remove_column :projects, :aasm_state
  end
end
