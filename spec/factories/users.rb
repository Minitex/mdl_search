FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }

    trait :admin do
      after(:build) do |user|
        user.user_roles = ['admin']
      end
    end
  end
end
