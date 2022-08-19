class Admins::SpeakersController < AdminsController
  before_action :set_speaker, only: [:edit, :update, :destroy]

  def index
    @speakers = Speaker.all
  end

  def new
    @speaker = Speaker.new
  end

  def edit
  end

  def create
    @speaker = Speaker.new(speaker_params)

    if current_user
      @speaker.created_by = set_current_user
      @speaker.updated_by = set_current_user
    end
    respond_to do |format|
      if @speaker.save
        format.html { redirect_to admins_speakers_path, notice: "Speaker was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user
      @speaker.updated_by = set_current_user
    end

    respond_to do |format|
      if @speaker.update(speaker_params)
        format.html { redirect_to admins_speakers_path, notice: "Speaker was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @speaker.destroy
    redirect_to admins_speakers_path, notice: "Speaker was successfully deleted."
  end

  protected

    def set_current_user
      user = User.full_name(current_user)
    end

    def set_speaker
      @speaker = Speaker.find(params[:id])
    end

    def speaker_params
      params.require(:speaker).permit(:full_name, :title, :description, :body)
    end
end
