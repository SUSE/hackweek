class CreateApiTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :api_tokens do |t|
      t.references :user, null: false, foreign_key: true, type: :integer
      t.string :name, null: false
      t.string :scope, null: false, default: 'read'
      t.string :token_digest, null: false
      t.datetime :last_used_at
      t.datetime :revoked_at

      t.timestamps
    end
    add_index :api_tokens, :token_digest, unique: true
  end
end
