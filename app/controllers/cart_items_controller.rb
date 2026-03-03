class CartItemsController < ApplicationController
  allow_unauthenticated_access

  def create
    product = Product.active.find(params[:product_id])
    @cart = current_cart
    @cart_item = @cart.add_product(product, (params[:quantity] || 1).to_i)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "#{product.name} added to cart." }
    end
  end

  def update
    @cart = current_cart
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.update(quantity: params[:quantity].to_i)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end

  def destroy
    @cart = current_cart
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Item removed from cart." }
    end
  end
end
