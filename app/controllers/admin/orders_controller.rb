module Admin
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update]

    def index
      @orders = Order.recent.includes(:user, :order_items)
      @pagy, @orders = pagy(@orders, limit: 20)
    end

    def show
    end

    def update
      if @order.update(order_params)
        redirect_to admin_order_path(@order), notice: "Order status updated."
      else
        redirect_to admin_order_path(@order), alert: "Could not update order."
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
