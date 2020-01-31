ThinkingSphinx::Index.define :project, name: :project_real_time, with: :real_time do
  indexes title
  indexes description
  indexes comment_texts

  has episode_ids, as: :episode_ids, type: :integer, multi: true
end

ThinkingSphinx::Index.define :project, name: :project_active_record, with: :active_record do
  indexes title
  indexes description
  indexes comments.text, :as => :comments
  indexes episodes.id, as: :episode_id
end
