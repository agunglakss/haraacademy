class OrdersController < ApplicationController
  protect_from_forgery except: :notification

  def show
    @course = Course.where(id: params[:id]).take
    if @course.nil? || current_user.nil?
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to new_user_session_path 
    else
      order = Order.where(course_id: @course.id, user_id: current_user.id).order(updated_at: :desc).take
      if order 
        if order.status == 'settlement'
          redirect_to course_path(@course.slug)
        elsif order.status == 'pending'
          flash[:alert] = "Anda sudah membeli kursus ini, harap hubungi admin untuk proses pembayaran."
          redirect_to root_path
        end
      end
    end
  end

  def create
    require 'veritrans'

    course = Course.where(id: params[:id]).take
    @order = Order.new 

    first_name = current_user.first_name
    last_name = current_user.last_name if !current_user.last_name.nil? 

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

    if @order.save
      mt_client = Midtrans.new(
        server_key: Rails.application.credentials.dig(:midtrans, :server_key),
        client_key: Rails.application.credentials.dig(:midtrans, :client_key),
        api_host: Rails.application.credentials.dig(:midtrans, :api_host), 
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
          first_name: first_name,
          last_name: last_name,
          email: current_user.email,
          phone: current_user.phone_number
        }
      )
    end
    @redirecturl = redirect_to result.redirect_url, allow_other_host: true
  end

  def notification
    # request from midtrans
    post_body = JSON.parse(request.body.read)

    # create instance Midtrans
    mt_client = Midtrans.new(
      server_key: Rails.application.credentials.dig(:midtrans, :server_key),
      logger: Logger.new(STDOUT), # optional
      file_logger: Logger.new(STDOUT), # optional
    )
    notification = mt_client.status(post_body['transaction_id'])
    puts "notifcation ----------- #{notification}"
    order_id = notification.data[:order_id] # data must match at tabel order
    payment_type = notification.data[:payment_type]
    transaction_status = notification.data[:transaction_status]
    fraud_status = notification.data[:fraud_status]
    status_code = notification.data[:status_code]
    gross_amount = notification.data[:gross_amount]
    puts "signatur #{notification.data[:signature_key]}"
    # check signature from midtrans
    concat_signatur = order_id + status_code.to_s + gross_amount.to_s + Rails.application.credentials.dig(:midtrans, :server_key)
    puts "concat_signatur #{concat_signatur}"
    signature = Digest::SHA512.hexdigest(concat_signatur)
    if(signature != notification.data[:signature_key])
      return "Transaction notification received. Order ID: #{order_id}. Transaction status: #{transaction_status}. Fraud status: #{fraud_status}"
    end

    order = Order.where(id: order_id).take
    
    if transaction_status == "settlement"
      my_course = MyCourse.new
      my_course.course_id = order.course_id
      my_course.user_id = order.user_id
      my_course.save
    end

    order.update(:status => transaction_status)

    payment_log = PaymentLog.new
    payment_log.status = transaction_status
    payment_log.order_id = order_id
    payment_log.payment_type = payment_type
    payment_log.raw_respone = notification
    payment_log.save
  end

  def send_to_whatsapp(status)
    account_sid = Rails.application.credentials.dig(:twilio, :account_sid),
    auth_token = Rails.application.credentials.dig(:twilio, :auth_token),
    @client = Twilio::REST::Client.new(account_sid, auth_token) 
    
    test_whatsapp = ''

    if status == 'pending'
      test_whatsapp = 'Your transaction is successfully, please make the payment.'
    elsif status == 'settlement'
      test_whatsapp = 'Your payment is successfully, thank you'
    end

    message = @client.messages.create( 
                                body: test_whatsapp,
                                from: 'whatsapp:+14155238886',       
                                to: 'whatsapp:+6285714061623' 
                              ) 
    
    puts message.sid
  end
end
