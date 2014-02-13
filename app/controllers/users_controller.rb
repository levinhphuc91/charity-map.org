require 'sms'
require 'social_share'
require 'charitio'

class UsersController < ApplicationController
  include SessionsHelper
  include GiftCardsHelper
  prepend_before_filter :authenticate_user!, except: [:profile, :verification_delivery_receipt, :fbnotif]
  before_filter :connect_backend_api, except: [:profile, :verification_delivery_receipt, :fbnotif]
  layout "layouts/dashboard", only: [
    :dashboard, :settings, :messages, :donations, :update_settings, :verify,
    :show_message, :new_message, :new_reply_message
  ]
  skip_before_filter :verify_authenticity_token, only: :fbnotif
  after_action :allow_facebook_iframe, only: :fbnotif

  def dashboard
  end

  def profile
    @user = User.find(params[:id] || current_user.id)
    @ext_project = ExtProject.new
  end

  def follow
    @followed = User.find(params[:followed])
    if current_user.follow!(@followed)
      redirect_to user_profile_path(@followed), notice: "Liked."
    else
      redirect_to user_profile_path(@followed), alert: "Unsuccessful."
    end
  end

  def settings
  	@user = current_user
  end

  def donations
  end

  def verify
  end

  def update_settings
  	@user = User.find(params[:user][:id])
  	if @user.update_attributes params[:user]
      if session_exist
        redirect_back
      else
        redirect_to users_settings_path
      end
      flash[:notice] = "Cập nhật thành công."
  	else
  		render :action => :settings, alert: "Cập nhật không thành công. #{@user.errors.full_messages.join}"
  	end
  end

  def add_figure_to_portfolio
    if params[:key].blank? || params[:value].blank?
      redirect_to users_profile_path, alert: "Cập nhật không thành công."
    else
      figures = (current_user.figures || {}).merge({"#{params[:key].html_safe}" => "#{params[:value].html_safe}"})
      if current_user.update_attributes :figures => figures
        redirect_to users_profile_path, notice: "Cập nhật thành công."
      else
        redirect_to users_profile_path, alert: "Cập nhật không thành công."
      end
    end
  end

  def delete_figure_from_portfolio
    @user = User.find(current_user.id)
    @figures = @user.figures.to_hash
    @figures = @figures.tap{ |h| h.delete("#{params[:key]}") }
    if current_user.update_attributes(:figures => @figures)
      respond_to do |format|
        format.js
      end
    else
      redirect_to users_profile_path, alert: "Cập nhật không thành công."
    end
  end

  def add_ext_project_to_portfolio
    @ext_project = ExtProject.new(params[:ext_project])
    if @ext_project.save
      redirect_to users_profile_path, notice: "Cập nhật thành công."
    else
      redirect_to users_profile_path, alert: "Cập nhật không thành công."
    end
  end

  def delete_ext_project_from_portfolio
    @ext_project = ExtProject.find(params[:ext_project])
    if (@ext_project.user == current_user) && @ext_project.destroy!
      redirect_to users_profile_path, notice: "Xoá dự án trước đây thành công."
    else
      redirect_to users_profile_path, alert: "Xoá dự án trước đây không thành công."
    end
  end

  def verification_code_via_phone
    if params[:phone_number]
      @phone_number = params[:phone_number].gsub(/\D/, '').to_i.to_s
      @verification = Verification.new(user_id: current_user.id)
      if @verification.save
        sms = SMS.send(to: @phone_number, text: "Ma so danh cho viec xac nhan danh tinh tai charity-map.org: #{@verification.code}") if Rails.env.production?
        @verification.update status: sms
        current_user.update(phone: @phone_number) if current_user.phone.blank?  
        redirect_to users_verify_path, notice: "Mã xác nhận vừa được gửi tới số +84#{@phone_number}. Mời bạn điền mã vào ô dưới để hoàn tất quá trình xác nhận."
      else
        redirect_to users_verify_path, alert: "Không thành công. Vui lòng thử lại."
      end
    elsif params[:phone_code]
      @verification = current_user.verification
      unless current_user.verified_by_phone
        current_user.update verified_by_phone: true
        @verification.update status: "USED"
        redirect_to users_verify_path, notice: "Xác nhận danh tính bằng số điện thoại hoàn tất."
      else
        redirect_to users_verify_path, alert: "Permission denied."
      end
    end
  end

  def resend_verification
    @phone_number = current_user.phone.gsub(/\D/, '').to_i.to_s
    @verification = current_user.verification
    if @verification.status == "UNUSED"
      @sms = SMS.send(to: @phone_number, text: "Ma so danh cho viec xac nhan danh tinh tai charity-map.org: #{@verification.code}") # if Rails.env.production?
      @verification.update status: @sms
    end
    redirect_to users_verify_path, notice: "Mã xác nhận đã được gửi đi tới số 0#{@phone_number}."
  end

  def verification_delivery_receipt
    if params["msisdn"]
      @user = User.find_by_phone("#{params["msisdn"].gsub("84","0")}")
      @user.verification.update_attributes :receipt => params
      render text: "#{params}", status: :ok
    else
      render :text => "Error.", status: :ok
    end
  end

  def messages
    @messages = current_user.messages
    @count_unreaded_messages = current_user.messages.unreaded.count
  end

  def show_message    
    @message = current_user.messages.with_id(params[:message_id]).first
    @message.mark_as_read
  end

  def new_message
    @id = params[:receiver]
    @user = User.find(@id)
    @message = ActsAsMessageable::Message.new
  end

  def create_message
    @id = params[:acts_as_messageable_message][:receiver]
    @receiver = User.find(@id)
    current_user.send_message(@receiver, params[:acts_as_messageable_message][:body])
    redirect_to :dashboard, notice: "Tin nhắn đã được gửi đi."
  end

  def new_reply_message
    @parent_message_id = params[:message_id]
    @parent_message = current_user.messages.with_id(params[:message_id]).first
    @parent_message.mark_as_read
    @message = ActsAsMessageable::Message.new
  end

  def reply_message
    @message = current_user.messages.with_id(params[:acts_as_messageable_message][:parent_message_id].to_i)
    @message.first.reply(params[:acts_as_messageable_message][:body])
    # redirect_to :back, notice: "Tin nhắn đã được gửi đi"
    redirect_to :dashboard, notice: "Tin nhắn đã được gửi đi."
  end
  
  def fbnotif
    @token = RedirectToken.find_by_value params[:token]
    if @token
      @url = redirect_via_token @token
    else
      @url = root_url
    end
  end

  def redeem_gift_card
    @gift_card = GiftCard.find_by(token: params[:card_token]) if params[:card_token]
    redeem_gift_card_from_signup(@gift_card, @user) if @gift_card
    redirect_to users_settings_path, notice: "Thẻ quà tặng được xác nhận. Tài khoản bạn được cộng thêm #{@gift_card.amount}."
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to new_user_session_path, alert: "Bạn cần đăng nhập để tiếp tục."
      end
    end

    def allow_facebook_iframe
      response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
    end

    def connect_backend_api
      if user_signed_in? && (@user = current_user)
        @charitio = Charitio.new(@user.email, @user.api_token)
        if @user.api_token.blank?
          @workoff = @charitio.create_user(email: @user.email, category: "INDIVIDUAL")
          if @workoff.ok?
            @user.update_attribute :api_token, @workoff.response["auth_token"]
          else
            redirect_to dashboard_path, alert: "API call not going through."
            logger.error(%Q{\
              [#{Time.zone.now}][User#connect_backend_api Charitio.create_user] \
                Affected user: #{@user.id} / Truncated email: #{@user.email.split('@').first} \
                API response: #{@workoff.response} \
              }
            )
          end
        end
      end
    end
end