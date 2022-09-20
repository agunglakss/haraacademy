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

    # cek jika coursenya ada dan user sudah login
    if course && !current_user.nil?
      total_price = course.price.to_i - course.discount.to_i
      detail_order = {
        price: course.price,
        diskon: course.discount.to_i,
        title: course.title,
        course_id: course.id,
        user_id: current_user.id,
        total_price: total_price.to_i
      }
      @order.course_id = course.id
      @order.user_id = current_user.id
      @order.metadata = detail_order

      @order.save
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
          gross_amount: total_price.to_i,
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
    redirect_to result.redirect_url, allow_other_host: true
  end

  def notification
    # request from midtrans
    post_body = JSON.parse(request.body.read)
    sk = Rails.application.credentials.dig(:midtrans, :server_key)

    # create instance Midtrans
    mt_client = Midtrans.new(
      server_key: Rails.application.credentials.dig(:midtrans, :server_key),
      client_key: Rails.application.credentials.dig(:midtrans, :client_key),
      api_host: Rails.application.credentials.dig(:midtrans, :api_host), 
    )
    notification = mt_client.status(post_body['transaction_id'])
    
    order_id = notification.data[:order_id] # data must match at tabel order
    payment_type = notification.data[:payment_type]
    transaction_status = notification.data[:transaction_status]
    fraud_status = notification.data[:fraud_status]
    status_code = notification.data[:status_code]
    gross_amount = notification.data[:gross_amount]
    
    # check signature from midtrans
    concat_signatur = order_id.to_s + status_code.to_s + gross_amount.to_s + sk
    
    signature = Digest::SHA512.hexdigest(concat_signatur)
    if(signature != notification.data[:signature_key])
      return "Transaction notification received. Order ID: #{order_id}. Transaction status: #{transaction_status}. Fraud status: #{fraud_status}"
    end

    # get data order
    order = Order.where(id: order_id).take
    
    if transaction_status == "settlement"
      # get data user
      user = User.where(id: order.user_id).take
      # get data course
      course = Course.where(id: order.course_id).take

      my_course = MyCourse.new
      my_course.course_id = order.course_id
      my_course.user_id = order.user_id
      my_course.save

      send_to_whatsapp(user.first_name, user.last_name, user.phone_number, course.slug)
    end

    order.update(:status => transaction_status)

    payment_log = PaymentLog.new
    payment_log.status = transaction_status
    payment_log.order_id = order_id
    payment_log.payment_type = payment_type
    payment_log.raw_respone = notification
    payment_log.save
  end

  def send_to_whatsapp(first_name, last_name = "", phone_number, slug)
    api_key = Rails.application.credentials.dig(:watzap, :api_key)
    number_key = Rails.application.credentials.dig(:watzap, :number_key)
    link = "https://haraacademy.id/courses/#{slug}"
    url = URI("https://api.watzap.id/v1/send_message")
    
    message = "Hi #{first_name} #{last_name},\nTerimakasih sudah mendaftar kelas di Hara Academy, link meeting akan tersedia sehari sebelum live.\n#{link} \nSee you very soon😘\n\nHara Academy"

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "api_key": "",
      "number_key": "",
      "phone_no": phone_number,
      "message": message
    })

    response = https.request(request)
    puts response.read_body
  end
end
