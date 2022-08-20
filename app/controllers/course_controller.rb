class CourseController < ApplicationController
  def index
    if params[:category].nil? || params[:category] == ""
      @courses = Course.all
      @total_course = Course.count
    else
      category = Category.where(name: params[:category]).take
      if category.nil?
        redirect_to courses_path
      end
      
      @courses = Course.where(category_id: category)
      @total_course = Course.where(category_id: category).count
    end
  end
end
