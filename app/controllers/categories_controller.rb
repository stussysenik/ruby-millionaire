class CategoriesController < ApplicationController
  allow_unauthenticated_access

  def show
    @category = Category.active.find_by!(slug: params[:id])
    @q = @category.products.active.ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.empty?
    @pagy, @products = pagy(@q.result, limit: 12)
    @subcategories = @category.children.active.ordered
  end
end
