module Admin
  class ProductsController < BaseController
    before_action :set_product, only: %i[show edit update destroy]

    def index
      @q = Product.ransack(params[:q])
      @q.sorts = "created_at desc" if @q.sorts.empty?
      @pagy, @products = pagy(@q.result.includes(:category), limit: 20)
    end

    def show
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_product_path(@product), notice: "Product created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: "Product updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Product deleted.", status: :see_other
    end

    private

    def set_product
      @product = Product.find_by!(slug: params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :sku, :description, :price_cents, :compare_at_price_cents,
        :stock_quantity, :category_id, :part_number, :mil_spec, :material,
        :certification, :weight_kg, :temperature_min, :temperature_max,
        :active, :featured, images: []
      )
    end
  end
end
