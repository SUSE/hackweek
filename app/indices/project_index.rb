ThinkingSphinx::Index.define :project, with: :active_record do
  indexes title
  indexes description

  # TODO index comments here

  has created_at, updated_at
end