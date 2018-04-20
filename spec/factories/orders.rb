FactoryGirl.define do
  factory :order do
    association(:user, factory: [:user, :confirmed])

    sequence(:customer_name) { |n| "Kunde #{n}" }
    country_code { %w[AT DE].sample }

    trait :placed do
      after(:create) do |order|
        order.place
      end
    end

    trait :accepted do
      customer_id { "#{(1000..9999).to_a.sample}-#{(1000..9999).to_a.sample}" }

      after(:create) do |order|
        order.accept
      end
    end
  end
end
