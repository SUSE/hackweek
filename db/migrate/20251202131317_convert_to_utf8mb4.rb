class ConvertToUtf8mb4 < ActiveRecord::Migration[7.2]
  # Tables that need utf8mb4 for emoji support in their text fields
  TABLES_TO_CONVERT = %w[
    announcements
    comments
    faqs
    projects
    updates
  ].freeze

  def up
    # Convert the database default charset
    execute "ALTER DATABASE `#{connection.current_database}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

    TABLES_TO_CONVERT.each do |table|
      execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    end
  end

  def down
    TABLES_TO_CONVERT.each do |table|
      execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin;"
    end

    execute "ALTER DATABASE `#{connection.current_database}` CHARACTER SET utf8 COLLATE utf8_general_ci;"
  end
end
