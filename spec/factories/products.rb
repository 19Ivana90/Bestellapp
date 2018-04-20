FactoryGirl.define do
  factory(:product) do
    sequence(:name) { |n| "Product #{n}" }

    carton_size { (5..100).to_a.sample }

    transient do
      available Hash.new
    end

    after(:build) do |product, evaluator|
      evaluator.available.each do |country_code, sku|
        create(:product_availability, product: product, country_code: country_code, sku: sku)
      end
    end
  end
end
