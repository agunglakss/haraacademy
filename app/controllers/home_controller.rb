class HomeController < ApplicationController
  def index
    @course = Course.includes(:category, :speaker).take
  end
end
