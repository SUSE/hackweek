class AddExpiresAtToApiTokens < ActiveRecord::Migration[7.2]
  def change
    add_column :api_tokens, :expires_at, :datetime
  end
end
