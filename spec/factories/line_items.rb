FactoryGirl.define do
  factory :line_item do
    association(:order)
    association(:product)

    quantity { [10, 20, 30, 40, 50, 60, 70, 80, 90, 100].sample }
  end
end
