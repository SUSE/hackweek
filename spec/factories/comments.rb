FactoryBot.define do
  factory :comment do
    commenter factory: %i[user]
    commentable factory: %i[project]

    text { 'Sample' }

    trait :with_nested_comments do
      after :create do |comment|
        3.times { comment.comments << create(:comment, commentable: comment) }
      end
    end
  end
end
