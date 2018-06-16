# This will guess the User class
FactoryBot.define do
  factory :episode do
    sequence(:name) { |n| "episode_#{n}" }
    start_date { 1.day.ago }
    end_date { 7.days.from_now }

    factory :active_episode do
      # ensure there is only one active episode
      after(:create) do |b|
        b.active = true
      end
    end
  end
end
