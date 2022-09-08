FactoryBot.define do
  factory :mdl_user, class: User do
    email { Faker::Internet.email }
    password { 'password' }

    trait :admin do
      after(:build) do |user|
        user.user_roles = ['admin']
      end
    end

    trait :visitor do
      after(:create) do |user|
        user.roles.delete_all
      end
    end
  end
end
