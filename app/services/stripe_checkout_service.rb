class StripeCheckoutService
  def initialize(cart, user)
    @cart = cart
    @user = user
  end

  def create_session(success_url:, cancel_url:)
    line_items = @cart.cart_items.includes(:product).map do |item|
      {
        price_data: {
          currency: "usd",
          product_data: {
            name: item.product.name,
            description: "SKU: #{item.product.sku} | Part: #{item.product.part_number}",
          },
          unit_amount: item.product.price_cents
        },
        quantity: item.quantity
      }
    end

    session_params = {
      mode: "payment",
      line_items: line_items,
      success_url: success_url.gsub("{CHECKOUT_SESSION_ID}", "{CHECKOUT_SESSION_ID}"),
      cancel_url: cancel_url,
      metadata: {
        cart_id: @cart.id,
        user_id: @user.id
      },
      shipping_address_collection: {
        allowed_countries: %w[US CA GB]
      }
    }

    session_params[:customer_email] = @user.email_address if @user

    Stripe::Checkout::Session.create(session_params)
  end
end
