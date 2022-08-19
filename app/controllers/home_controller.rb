class HomeController < ApplicationController
  def index
    @courses_playback = Course.includes(:category, :speaker).by_status_and_type('playback').order(:created_at).limit(4)
    @courses_live = Course.includes(:category, :speaker).by_status_and_type('live').order(:created_at).limit(4)
  end
end
