class CartsController < ApplicationController
  allow_unauthenticated_access

  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(product: { images_attachments: :blob })
  end
end
