FactoryBot.define do
  factory :notification, class: Notification do
    read_at { nil }
    recipient_id { 1 }
    action { 'string' }
    association :actor, factory: :user
    association :notifiable, factory: :project
  end
end
