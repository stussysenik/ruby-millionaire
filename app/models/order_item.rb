class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price_cents, numericality: { greater_than: 0 }
  validates :product_name, :product_sku, presence: true

  def line_total_cents
    unit_price_cents * quantity
  end

  def line_total
    line_total_cents / 100.0
  end
end
