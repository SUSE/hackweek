class ConvertToUtf8mb4 < ActiveRecord::Migration[7.2]
  # Tables that need utf8mb4 for emoji support in their text fields
  TABLES_TO_CONVERT = %w[
    announcements
    comments
    faqs
    projects
    updates
    episodes
    roles
    users
    active_storage_attachments
    active_storage_blobs
    active_storage_variant_records
    impressions
    keywords
    notifications
  ].freeze

  def up
    # Convert the database default charset
    execute "ALTER DATABASE `#{connection.current_database}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

    # Convert the table default charset
    connection.tables.each do |table|
      execute "ALTER TABLE `#{table}` ROW_FORMAT=DYNAMIC CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    end

    # Convert the charset of data in tables
    TABLES_TO_CONVERT.each do |table|
      execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
