class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  delegate :name, :carton_size, to: :product, prefix: true

  def product_sku
    @product_sku ||= product.sku_for(order.country_code)
  end
end
