class Product < ApplicationRecord
  has_many :availabilities, class_name: 'ProductAvailability'

  scope :by_name, -> { order(name: :asc) }

  def self.search(term, options = {})
    sql = "(name ILIKE :term_for_match OR sku = :term)"
    values = { term_for_match: "%#{term}%", term: term }

    if options[:country_code].present?
      sql << " AND country_code = :country_code"
      values[:country_code] = options[:country_code]
    end

    joins(:availabilities).where(sql, values).distinct
  end

  def sku_for(country_code)
    availabilities.for_country(country_code).first.try(:sku)
  end
end
