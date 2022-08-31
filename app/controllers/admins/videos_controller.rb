class Admins::VideosController < AdminsController
  before_action :authenticate_user!
  before_action :is_admin?
  before_action :set_video, only: [:edit, :update, :destroy]

  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
  end

  def edit
  end

  def create
    @video = Video.new(video_params)

    # if current_user
    #   @video.created_by = set_current_user
    #   @video.updated_by = set_current_user
    # end
    respond_to do |format|
      if @video.save
        format.html { redirect_to admins_videos_path, notice: "Video was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # if current_user
    #   @video.updated_by = set_current_user
    # end

    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to admins_videos_path, notice: "Video was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video.destroy
    redirect_to admins_videos_path, notice: "Video was successfully deleted."
  end

  protected

    def set_current_user
      user = User.full_name(current_user)
    end

    def set_video
      @video = Video.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:course_id, :subject, :url_video)
    end

    def is_admin?
      if current_user.role != 'admin'
        redirect_to root_path
      end
    end
end
