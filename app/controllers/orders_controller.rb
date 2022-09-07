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
    require 'veritrans'
    course = Course.where(id: params[:id]).take
    @order = Order.new 
    if course && !current_user.nil?
        
        @order.status = 'unpaid'
        @order.course_id = course.id
        @order.user_id = current_user.id
        
    end

    if @order.save
      mt_client = Midtrans.new(
      server_key: "SB-Mid-server-t_7OHErrySsJ4HF_M9kUngkC",
      client_key: "SB-Mid-client-ouyDCkaQENXIAQjT",
      api_host: "https://api.sandbox.midtrans.com", # default
      http_options: { }, # optional
      logger: Logger.new(STDOUT), # optional
      file_logger: Logger.new(STDOUT), # optional
    )
    result = mt_client.create_snap_redirect_url(
      transaction_details: {
        order_id: @order.id,
        gross_amount: course.price,
        secure: true
      },
      item_details: {
        id: course.id,
        price: course.price,
        name: course.title,
        quantity: 1
      }
    )
  end
  
  redirect_to result.redirect_url, allow_other_host: true
  end
end
