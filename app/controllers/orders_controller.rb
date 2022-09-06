class OrdersController < ApplicationController
  def show
    @course = Course.where(id: params[:id]).take
    if @course.nil? || current_user.nil?
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to new_user_session_path 
    else
      order = Order.where(course_id: @course.id, user_id: current_user.id).last
      if order && order.status == 'paid'
        redirect_to course_path(@course.slug)
      elsif order && order.status == 'unpaid'
        flash[:alert] = "Anda sudah membeli kursus ini, harap hubungi admin untuk proses pembayaran."
        redirect_to root_path
      end
    end
  end

  def create
    course = Course.where(id: params[:id]).take

    if course && !current_user.nil?
        order = Order.new 
        order.status = 'unpaid'
        order.course_id = course.id
        order.user_id = current_user.id
        order.save
    end
    
    
  end
end
