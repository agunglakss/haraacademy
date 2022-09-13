class HomeController < ApplicationController
  def index
    @course = Course.includes(:category, :speaker).where(status: 'published').take
  end
end
