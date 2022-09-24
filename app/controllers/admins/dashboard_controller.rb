class Admins::DashboardController < AdminsController
  before_action :authenticate_user!
  before_action :is_admin?

  def index
    @orders = Order.includes(:user, :course)
    @total_order_today = Order.where(created_at: Date.today).count
    @total_user_join_today = User.where(created_at: Date.today).count
    @total_user = User.count

  end

  protected
  def is_admin?
    if current_user.role != 'admin'
      redirect_to root_path
    end
  end
end