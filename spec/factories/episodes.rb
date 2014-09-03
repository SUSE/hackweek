# This will guess the User class
FactoryGirl.define do
  factory :episode do
    name 1 
    start_date { 1.day.ago }
    end_date { 7.days.from_now } 
  end
end
