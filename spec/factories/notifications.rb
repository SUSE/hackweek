FactoryBot.define do
  factory :notification, class: Notification do
    read_at { nil }
    recipient_id { 1 }
    action { 'string' }
    actor factory: %i[user]
    notifiable factory: %i[project]
  end
end
