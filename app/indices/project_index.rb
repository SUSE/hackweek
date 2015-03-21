ThinkingSphinx::Index.define :project, with: :active_record do
  indexes title
  indexes description

  has created_at, updated_at
end