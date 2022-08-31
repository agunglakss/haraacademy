class Admins::CoursesController < AdminsController
  before_action :authenticate_user!
  before_action :is_admin?
  
  before_action :set_course, only: [:edit, :update, :destroy]

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)

    if current_user
      @course.created_by = set_current_user
      @course.updated_by = set_current_user
    end
    respond_to do |format|
      if @course.save
        format.html { redirect_to admins_courses_path, notice: "Course was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user
      @course.updated_by = set_current_user
    end

    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to admins_courses_path, notice: "Course was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @course.destroy
    redirect_to admins_courses_path, notice: "Course was successfully deleted."
  end

  protected

    def set_current_user
      user = User.full_name(current_user)
    end

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :slug, :price, :discount, :date, :sort, :status, :created_by, :updated_by, :category_id, :speaker_id, :slug, :image, :body)
    end

    def is_admin?
      if current_user.role != 'admin'
        redirect_to root_path
      end
    end
end
