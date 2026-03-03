class CheckoutsController < ApplicationController
  def create
    cart = current_cart
    redirect_to cart_path, alert: "Your cart is empty." and return if cart.empty?

    checkout_session = StripeCheckoutService.new(cart, current_user).create_session(
      success_url: success_checkouts_url(session_id: "{CHECKOUT_SESSION_ID}"),
      cancel_url: cancel_checkouts_url
    )

    redirect_to checkout_session.url, allow_other_host: true, status: :see_other
  end

  def success
    @session_id = params[:session_id]
    @order = Order.find_by(stripe_checkout_session_id: @session_id)
  end

  def cancel
  end
end
