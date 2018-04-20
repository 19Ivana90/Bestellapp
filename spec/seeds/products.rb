require 'csv'

CSV.foreach(Rails.root.join('spec/seeds/products.csv'), headers: true, force_quotes: true) do |line|
  product = FactoryGirl.create(:product, line.to_h.slice('name', 'carton_size'))

  %w[at de].each do |country_code|
    next unless (sku = line["sku_#{country_code}"]).present?

    FactoryGirl.create(:product_availability, product: product, country_code: country_code.upcase, sku: sku)
  end
end
