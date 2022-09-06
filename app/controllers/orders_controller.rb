class OrdersController < ApplicationController
  def show
    @course = Course.where(id: params[:id]).take
    redirect_to root_path if @course.nil? || current_user.nil?
  end

  def create
    course = Course.where(id: params[:id]).take

    if course && !current_user.nil?
      order = Order.where(course_id: course.id, user_id: current_user.id).take
      if order
        redirect_to root_path
      else
        order = Order.new 
        order.status = 'unpaid'
        order.course_id = course.id
        order.user_id = current_user.id
        
        order.save
      end
    end
    
    
  end
end
