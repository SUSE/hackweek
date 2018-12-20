FactoryBot.define do
  factory :comment do
    association :commenter, factory: :user
    association :commentable, factory: :project

    text { "Sample" }

    trait :with_nested_comments do
      after :create do |comment|
        3.times { comment.comments << create(:comment, commentable: comment) }
      end
    end
  end
end