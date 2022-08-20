class CourseController < ApplicationController
  def index
    @categories = Category.all
    @speakers = Speaker.all
    @courses = Course.all
  end
end
