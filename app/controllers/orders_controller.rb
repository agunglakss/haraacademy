class OrdersController < ApplicationController
  protect_from_forgery except: :notification

  def show
    @course = Course.where(id: params[:id]).take
    if @course.nil? || current_user.nil?
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to new_user_session_path 
    else
      order = Order.where(course_id: @course.id, user_id: current_user.id).last
      if order && order.status == 'settlement'
        redirect_to course_path(@course.slug)
      elsif order && order.status == 'pending'
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
      total_price = course.price - course.discount.to_i
      detail_order = {
        price: course.price,
        diskon: course.discount.to_i,
        title: course.title,
        course_id: course.id,
        user_id: current_user.id,
        total_price: total_price
      }
      @order.course_id = course.id
      @order.user_id = current_user.id
      @order.metadata = detail_order
    end

    @order.save
      mt_client = Midtrans.new(
      server_key: ENV["MIDTRANS_SERVER_KEY"],
      client_key: ENV["MIDTRANS_CLIENT_KEY"],
      api_host: "https://api.sandbox.midtrans.com", # default
      logger: Logger.new(STDOUT), # optional
      file_logger: Logger.new(STDOUT), # optional
    )

    result = mt_client.create_snap_redirect_url(
      transaction_details: {
        order_id: @order.id,
        gross_amount: total_price,
        secure: true
      },
      item_details: {
        id: course.id,
        price: total_price,
        name: course.title,
        quantity: 1
      },
      customer_details: {
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        phone: current_user.phone_number
      }
    )
  
  redirect_to result.redirect_url, allow_other_host: true
  end

  def notification
    post_body = JSON.parse(request.body.read)
    mt_client = Midtrans.new(
      server_key: ENV["MIDTRANS_SERVER_KEY"],
      logger: Logger.new(STDOUT), # optional
      file_logger: Logger.new(STDOUT), # optional
    )
    notification = mt_client.status(post_body['transaction_id'])

    order_id = notification.data[:order_id] # data must match at tabel order
    payment_type = notification.data[:payment_type]
    transaction_status = notification.data[:transaction_status]
    fraud_status = notification.data[:fraud_status]
    status_code = notification.data[:status_code]
    gross_amount = notification.data[:gross_amount]

    puts "Transaction order_id: #{order_id}"
    puts "Payment type:   #{payment_type}"
    puts "Transaction status: #{transaction_status}"
    puts "Fraud status:   #{fraud_status}"
    
    # signature
    concat_signatur = order_id + status_code.to_s + gross_amount.to_s + "SB-Mid-server-t_7OHErrySsJ4HF_M9kUngkC"
    signature = Digest::SHA512.hexdigest(concat_signatur)
    if(signature != notification.data[:signature_key])
      return "Transaction notification received. Order ID: #{order_id}. Transaction status: #{transaction_status}. Fraud status: #{fraud_status}"
    end

    order = Order.where(id: order_id).take

    payment_log = PaymentLog.new

    # Sample transactionStatus handling logic
    if transaction_status == "capture" && fraud_status == "challange"
      order.status = "capture"
    elsif transaction_status == "capture" && fraud_status == "success"
      order.status = "success"
    elsif transaction_status == "settlement"
      order.status = "settlement"
    elsif transaction_status == "deny"
      order.status = "deny"
    elsif transaction_status == "cancel" || transaction_status == "expire"
      order.status = "cancel"
    elsif transaction_status == "pending"
      order.status = "pending"
    end
    payment_log.status = transaction_status
    payment_log.order_id = order_id
    payment_log.payment_type = payment_type
    payment_log.raw_respone = notification
    payment_log.save
    order.update(:status => transaction_status)
  end
end
