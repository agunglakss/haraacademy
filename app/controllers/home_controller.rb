class HomeController < ApplicationController
  def index
    @course = Course.includes(:category, :speaker).take
    # @courses_live = Course.includes(:category, :speaker).by_status_and_type('live').order(:created_at).limit(4)
    # @categories = Category.select(:name).order(sequence: :asc).take(3)
  end
end
