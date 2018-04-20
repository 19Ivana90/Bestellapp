FactoryGirl.define do
  factory(:user) do
    sequence(:email) { |n| "user#{n}@example.com" }

    sequence(:first_name) { |n| "Chuck #{n + 1}" }
    sequence(:last_name) { |n| "Norris #{n + 1}" }

    password { '12345678' }

    role 'user'

    trait(:confirmed) do
      after(:build) do |user|
        user.skip_confirmation!
      end
    end

    trait(:admin) do
      role 'admin'
    end
  end
end
