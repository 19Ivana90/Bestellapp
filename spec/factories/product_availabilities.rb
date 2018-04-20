FactoryGirl.define do
  factory(:product_availability) do
    association(:product)

    country_code { %w[AT DE].sample }
    sequence(:sku, 1000) { |n| "#{country_code == 'DE' ? '6' : ''}#{n}" }
  end
end
