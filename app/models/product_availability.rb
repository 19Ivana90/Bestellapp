class ProductAvailability < ApplicationRecord
  belongs_to :product

  scope :for_country, ->(country_code) { where(country_code: country_code) }
end
