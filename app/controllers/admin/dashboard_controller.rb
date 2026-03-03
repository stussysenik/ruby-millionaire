module Admin
  class DashboardController < BaseController
    def index
      @total_revenue = Order.where.not(status: :cancelled).sum(:total_cents)
      @total_orders = Order.count
      @total_users = User.count
      @total_products = Product.count
      @recent_orders = Order.recent.includes(:user, :order_items).limit(10)
      @low_stock_products = Product.active.where("stock_quantity <= 5").order(:stock_quantity).limit(10)
    end
  end
end
