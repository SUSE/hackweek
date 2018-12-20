# This will guess the User class
FactoryBot.define do
  factory :all_states, class: Project do
    sequence(:title) { Faker::Lorem.sentence }
    sequence(:description) { Faker::Lorem.paragraph }
    
    likes_count { 0 }
    memberships_count { 0 }
    aasm_state { 'idea' }
    association :originator, factory: :user

    factory :idea, class: Project do
      aasm_state { 'idea' }
    end
    factory :project, class: Project do
      aasm_state { 'project' }
      after(:create) { |project| project.users << create(:user) }
    end
    factory :invention, class: Project do
      aasm_state { 'invention' }
      after(:create) { |project| project.users << create(:user) }
    end
    factory :record, class: Project do
      aasm_state { 'record' }
    end

    trait :with_comments do
      after :create do |project|
        2.times { project.comments << create(:comment, commentable: project) }
      end
    end
  end
end
