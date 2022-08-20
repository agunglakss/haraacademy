class HomeController < ApplicationController
  def index
    @courses_playback = Course.includes(:category, :speaker).by_status_and_type('playback').order(:created_at).limit(4)
    @courses_live = Course.includes(:category, :speaker).by_status_and_type('live').order(:created_at).limit(4)
  end

  def format_number(number)
    num_groups = number.to_s.chars.to_a.reverse.each_slice(3)
    num_groups.map(&:join).join(',').reverse
  end
end
