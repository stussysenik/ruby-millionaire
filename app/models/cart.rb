class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product, quantity = 1)
    item = cart_items.find_or_initialize_by(product: product)
    item.quantity = item.new_record? ? quantity : item.quantity + quantity
    item.save
    item
  end

  def subtotal_cents
    cart_items.includes(:product).sum { |item| item.line_total_cents }
  end

  def subtotal
    subtotal_cents / 100.0
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.empty?
  end

  def merge!(other_cart)
    return if other_cart.nil? || other_cart == self

    other_cart.cart_items.each do |other_item|
      existing = cart_items.find_by(product_id: other_item.product_id)
      if existing
        existing.update(quantity: existing.quantity + other_item.quantity)
      else
        other_item.update(cart: self)
      end
    end
    other_cart.reload.destroy
  end
end
