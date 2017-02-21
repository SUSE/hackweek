ThinkingSphinx::Index.define :project, name: :project_real_time, with: :real_time do
  indexes title
  indexes description
  indexes comment_texts
end

ThinkingSphinx::Index.define :project, name: :project_active_record, with: :active_record do
  indexes title
  indexes description
  indexes comments.text, :as => :comments
end
