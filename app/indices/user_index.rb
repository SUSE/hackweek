ThinkingSphinx::Index.define :user, name: :user_real_time, with: :real_time do
  indexes name
end

ThinkingSphinx::Index.define :user, name: :user_active_record, with: :active_record do
  indexes name
end
