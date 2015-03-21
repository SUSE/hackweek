ThinkingSphinx::Index.define :user, with: :active_record do
  indexes name

  has created_at, updated_at
end