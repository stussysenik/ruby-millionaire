module Account
  class OrdersController < ApplicationController
    def index
      @orders = current_user.orders.recent.includes(:order_items)
    end

    def show
      @order = current_user.orders.find(params[:id])
    end
  end
end
