class CourseController < ApplicationController
  def index
    @categories = Category.all
    @speakers = Speaker.all
  end
end
