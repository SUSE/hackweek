ThinkingSphinx::Index.define :project, name: :project_real_time, with: :real_time do
  indexes title
  indexes description

  # TODO index comments here
end

ThinkingSphinx::Index.define :project, name: :project_active_record, with: :active_record do
  indexes title
  indexes description

  # TODO index comments here
end