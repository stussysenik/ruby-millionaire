class ProductsController < ApplicationController
  allow_unauthenticated_access

  def index
    @q = Product.active.ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.empty?
    scope = @q.result.includes(:category)
    scope = scope.by_category(params[:category_id]) if params[:category_id].present?
    @pagy, @products = pagy(scope, limit: 12)
    @categories = Category.active.roots.ordered.includes(:children)
  end

  def show
    @product = Product.active.find_by!(slug: params[:id])
    @related_products = Product.active.where(category: @product.category).where.not(id: @product.id).limit(4)
  end
end
