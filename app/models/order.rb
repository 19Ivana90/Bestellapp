class Order < ApplicationRecord
  belongs_to :user

  has_many :line_items, -> { order(id: :asc) }
  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: ->(attributes) {
    (attributes['id'].blank? && attributes['product_id'].blank?) || attributes['quantity'].to_i < 1
  }

  validates :customer_name, presence: true
  validates :country_code, presence: true, inclusion: { in: COUNTRIES.invert.keys, allow_blank: true }
  validates :customer_id, presence: { if: :accepted? }

  scope :open, -> { where(placed_at: nil) }
  scope :placed, -> { where.not(placed_at: nil) }
  scope :unaccepted, -> { placed.where(accepted_at: nil) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :asc, -> { order(:id) }

  def self.next_number
    sprintf('%05d', (maximum(:number) || ENV['ORDER_NUMBERS_OFFSET']).to_i + 1)
  end

  def line_items_attributes=(line_items_attributes)
    line_items_attributes.each do |key, attributes|
      next if attributes.key?('id')

      existing_line_item_for_product = line_items.find_by(product_id: attributes['product_id'])
      next unless existing_line_item_for_product.present?

      attributes['id'] = existing_line_item_for_product.id
      attributes['quantity'] = attributes['quantity'].to_i + existing_line_item_for_product.quantity
    end

    super
  end

  def customer_name_and_id
    customer_name_and_id = customer_name
    customer_name_and_id << " (#{customer_id})" if customer_id.present?
    customer_name_and_id
  end

  def country_name
    COUNTRIES.invert[country_code]
  end

  def line_items_count
    line_items.count
  end

  def editable?
    !placed?
  end

  def placed?
    placed_at.present?
  end

  def place
    update!(placed_at: Time.current) unless placed?
  end

  def accepted?
    accepted_at.present?
  end

  def accept(attributes = {})
    return if accepted?

    update(attributes.merge(accepted_at: Time.current, number: self.class.next_number))
  end

  def receipt_group
    country_code == 'AT' ? '00' : '31'
  end

  def to_bueroware_dta
    separator = 'þ'
    formatted_date = placed_at.to_date.strftime('%d.%m.%Y')

    ''.tap do |txt|
      variables = {
        SKZ: 'BEL',
        UEBER: 'N',
        PROT: 'J',
        FOSTAND: 'J',
        STAMMKALK: 'J',
        ac: 'A',
        ad: number,
        ae: customer_id,
        af: formatted_date,
        jh: receipt_group # receipt group
      }

      txt << separator
      txt << variables.map { |name, value| "#{name}#{separator}#{value}" }.join(separator)
      txt << "#{separator}\r\n"
      line_items.each do |line_item|
        variables = {
          SKZ: 'POS',
          UEBER: 'N',
          PROT: 'J',
          FOSTAND: 'J',
          STAMMKALK: 'J',
          POSDATERG: 'J',
          ac: 'A',
          af: line_item.product_sku,
          av: line_item.quantity.to_s
        }

        txt << separator
        txt << variables.map { |name, value| "#{name}#{separator}#{value}" }.join(separator)
        txt << "#{separator}\r\n"
      end
    end.encode('ISO-8859-1')
  end
end
