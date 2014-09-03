# This will guess the User class
FactoryGirl.define do
  factory :all_states, class: Project do
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    likes_count 0
    memberships_count 0
    aasm_state 'idea'
    association :originator, factory: :user

    factory :idea, class: Project do
      aasm_state 'idea'
    end
    factory :project, class: Project do
      aasm_state 'project'
    end
    factory :invention, class: Project do
      aasm_state 'invention'
    end
    factory :record, class: Project do
      aasm_state 'record'
    end
  end
end
