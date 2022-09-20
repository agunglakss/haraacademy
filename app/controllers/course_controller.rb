class CourseController < ApplicationController
  def index
    @courses = Course.includes(:category)
    
    category = Category.select(:id).where(name: params[:category]).take
    
    speaker = Speaker.select(:id).where(full_name: params[:speaker]).take

    @courses = @courses.where(sort: params[:type]) unless params[:type].nil?
    # jika parameter kategori jika tidak kosong tampilkan berdasarakan kategori
    @courses = @courses.by_category(category) unless category.nil?
    # jika parameter speaker jika tidak kosong tampilkan berdasarkan speaker
    @courses = @courses.by_speaker(speaker) unless speaker.nil?
     # jika parameter kosong maka tampilkan semua course order by created_at descending
    @courses = @courses.order(created_at: :desc).page(params[:page]).per(10)
    # total kursus
    @total_course = @courses.count
  end

  def show
    @course = Course.includes(:speaker, :category).where(slug: params[:slug]).take
    if @course.nil? || current_user.nil?
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to new_user_session_path 
    end
    my_course = MyCourse.where(course_id: @course.id, user_id: current_user.id).take
    redirect_to root_path unless my_course
  end
end
