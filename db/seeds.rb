require 'csv'

%w[at de].each do |country_code|
  CSV.foreach(Rails.root.join("db/seeds/products_#{country_code}.csv"), headers: true, col_sep: ';') do |line|
    product = Product.where(name: line['Artikeltext'].strip).first_or_create!(carton_size: line['Stk/Karton'])
    ProductAvailability.where(sku: line['Artikelnummer'].strip).first_or_create!(product: product, country_code: country_code.upcase)
  end
end

User.where(email: 'clemens@railway.at').first_or_create!(
  first_name: 'Clemens',
  last_name: 'Kofler',
  password: '12345678',
  role: 'admin'
) { |user| user.skip_confirmation! }
