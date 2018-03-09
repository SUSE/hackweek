ThinkingSphinx::Index.define :project, name: :project_real_time, with: :real_time do
  indexes title
  indexes description
  indexes comment_texts
  indexes episode_names
end

ThinkingSphinx::Index.define :project, name: :project_active_record, with: :active_record do
  indexes title
  indexes description
  indexes comments.text, :as => :comments
  indexes episodes.name, as: :episode_names
end
