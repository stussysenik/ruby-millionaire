module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[show edit update]

    def index
      @pagy, @users = pagy(User.order(created_at: :desc), limit: 20)
    end

    def show
      @orders = @user.orders.recent.limit(10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :phone, :admin)
    end
  end
end
