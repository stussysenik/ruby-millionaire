class OrderCreationService
  def initialize(checkout_session)
    @checkout_session = checkout_session
  end

  def call
    return if Order.exists?(stripe_checkout_session_id: session_id)

    ActiveRecord::Base.transaction do
      order = create_order
      create_order_items(order)
      decrement_stock
      clear_cart
      order
    end
  end

  private

  def session_id
    @checkout_session.is_a?(Hash) ? @checkout_session[:id] : @checkout_session.id
  end

  def metadata
    if @checkout_session.is_a?(Hash)
      @checkout_session[:metadata]
    else
      @checkout_session.metadata
    end
  end

  def shipping_details
    if @checkout_session.is_a?(Hash)
      @checkout_session.dig(:shipping_details, :address) || {}
    else
      @checkout_session.shipping_details&.address || OpenStruct.new
    end
  end

  def user
    @user ||= User.find(metadata[:user_id] || metadata["user_id"])
  end

  def cart
    @cart ||= Cart.find(metadata[:cart_id] || metadata["cart_id"])
  end

  def amount_total
    if @checkout_session.is_a?(Hash)
      @checkout_session[:amount_total]
    else
      @checkout_session.amount_total
    end
  end

  def payment_intent
    if @checkout_session.is_a?(Hash)
      @checkout_session[:payment_intent]
    else
      @checkout_session.payment_intent
    end
  end

  def create_order
    shipping = shipping_details
    Order.create!(
      user: user,
      stripe_checkout_session_id: session_id,
      stripe_payment_intent_id: payment_intent,
      subtotal_cents: cart.subtotal_cents,
      shipping_cents: 0,
      tax_cents: 0,
      total_cents: amount_total,
      status: :confirmed,
      shipping_name: shipping.try(:name) || shipping[:name],
      shipping_line1: shipping.try(:line1) || shipping[:line1],
      shipping_line2: shipping.try(:line2) || shipping[:line2],
      shipping_city: shipping.try(:city) || shipping[:city],
      shipping_state: shipping.try(:state) || shipping[:state],
      shipping_postal_code: shipping.try(:postal_code) || shipping[:postal_code],
      shipping_country: shipping.try(:country) || shipping[:country]
    )
  end

  def create_order_items(order)
    cart.cart_items.includes(:product).each do |cart_item|
      order.order_items.create!(
        product: cart_item.product,
        quantity: cart_item.quantity,
        unit_price_cents: cart_item.product.price_cents,
        product_name: cart_item.product.name,
        product_sku: cart_item.product.sku
      )
    end
  end

  def decrement_stock
    cart.cart_items.includes(:product).each do |cart_item|
      cart_item.product.decrement!(:stock_quantity, cart_item.quantity)
    end
  end

  def clear_cart
    cart.cart_items.destroy_all
  end
end
