class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_cart, :current_user

  private

  def current_user
    Current.session&.user
  end

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    if current_user
      current_user.cart || current_user.create_cart
    else
      Cart.find_by(session_id: session.id.to_s) || Cart.create(session_id: session.id.to_s)
    end
  end

  def merge_guest_cart_on_sign_in
    guest_cart = Cart.find_by(session_id: session.id.to_s)
    return unless guest_cart && current_user

    user_cart = current_user.cart || current_user.create_cart
    user_cart.merge!(guest_cart)
  end
end
