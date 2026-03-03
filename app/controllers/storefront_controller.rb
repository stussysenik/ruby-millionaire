class StorefrontController < ApplicationController
  allow_unauthenticated_access

  def index
    @featured_products = Product.active.featured.includes(:category).limit(8)
    @categories = Category.active.roots.ordered.includes(:children)
    @products_count = Product.active.count
    @categories_count = Category.active.count
  end
end
