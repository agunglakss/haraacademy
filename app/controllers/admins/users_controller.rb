class Admins::UsersController < AdminsController
  before_action :authenticate_user!
  before_action :is_admin?
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admins_users_path, notice: "User was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to admins_users_path, notice: "User was successfully deleted."
  end

  protected

  def set_current_user
    user = User.full_name(current_user)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :role)
  end

  def is_admin?
    if current_user.role != 'admin'
      redirect_to root_path
    end
  end

end