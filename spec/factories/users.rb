# This will guess the User class
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }

    factory :admin, class: User do
      name { 'Admin' }
      after(:create) { |user| user.role_ids = create(:admin_role).id }
    end
    factory :organizer, class: User do
      name { 'Organizer' }
      after(:create) { |user| user.role_ids = create(:organizer_role).id }
    end
  end
end
