class CourseController < ApplicationController
  def index
    @courses = Course.includes(:category)
    
    category = Category.select(:id).where(name: params[:category]).take
    
    speaker = Speaker.select(:id).where(full_name: params[:speaker]).take

    # jika parameter kategori jika tidak kosong tampilkan berdasarakan kategori
    @courses = @courses.by_category(category) unless category.nil?
    # jika parameter speaker jika tidak kosong tampilkan berdasarkan speaker
    @courses = @courses.by_speaker(speaker) unless speaker.nil?
     # jika parameter kosong maka tampilkan semua course order by created_at descending
    @courses = @courses.order(created_at: :desc)
    # total kursus
    @total_course = @courses.count
  end

  def show
  end
end
