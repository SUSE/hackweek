FactoryBot.define do
  factory :role do
    name { 'rolename' }

    factory :admin_role do
      name { 'admin' }
    end
    factory :organizer_role do
      name { 'admin' }
    end
  end
end
