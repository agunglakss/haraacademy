class Admins::CategoriesController < AdminsController
  before_action :authenticate_user!
  before_action :is_admin?
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if current_user
      @category.created_by = set_current_user
      @category.updated_by = set_current_user
    end
    respond_to do |format|
      if @category.save
        format.html { redirect_to admins_categories_path, notice: "Category was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user
      @category.updated_by = set_current_user
    end

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admins_categories_path, notice: "Category was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy
    redirect_to admins_categories_path, notice: "Category was successfully deleted."
  end

  protected

    def set_current_user
      user = User.full_name(current_user)
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :icon, :sequence, :color)
    end

    def is_admin?
      if current_user.role != 'admin'
        redirect_to root_path
      end
    end
end
