class HomeController < ApplicationController
  def index
    @courses = Course.includes(:category, :speaker).where(status: 'published')
  end
end
