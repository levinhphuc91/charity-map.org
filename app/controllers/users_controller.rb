require 'sms'

class UsersController < ApplicationController
  include SessionsHelper
  before_filter :authenticate_user!, except: [:profile, :verification_delivery_receipt]
  layout "layouts/dashboard", only: [
    :dashboard, :settings, :messages, :donations, :update_settings, :verify,
    :show_message, :new_message, :new_reply_message
  ]

  def dashboard
  end

  def profile
    @user = User.find(params[:id]) || current_user
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
  	if (@user.update params[:user]) && (@user.settings(:profile).update_attributes! portfolio: (params[:profile_portfolio] == 1 ? true : false) )
      if session_exist
        redirect_back
      else
        redirect_to users_settings_path
      end
      flash[:notice] = "Cập nhật thành công."
  	else
  		render :action => :settings, alert: "Cập nhật không thành công."
  	end
  end

  def verification_code_via_phone
    if params[:phone_number]
      @phone_number = params[:phone_number].gsub(/\D/, '').to_i.to_s
      @verification = Verification.new(user_id: current_user.id)
      if @verification.save
        sms = SMS.send(@phone_number, "(Charity Map) Ma so danh cho viec xac nhan danh tinh tai charity-map.org: #{@verification.code}") if Rails.env.production?
        current_user.update(phone: @phone_number) if current_user.phone.blank?  
        redirect_to users_verify_path, notice: "Mã xác nhận vừa được gửi tới số +84#{@phone_number}. Mời bạn điền mã vào ô dưới để hoàn tất quá trình xác nhận."
      else
        redirect_to users_verify_path, alert: "Không thành công. Vui lòng thử lại."
      end
    elsif params[:phone_code]
      @verification = Verification.where(user_id: current_user.id, code: params[:phone_code], status: "UNUSED").first
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
    @verification = current_user.verifications.where(:status => "UNUSED").first
    sms = SMS.send(@phone_number, "Ma so danh cho viec xac nhan danh tinh tai charity-map.org: #{@verification.code}") #if Rails.env.production?
    redirect_to users_verify_path, notice: "Mã xác nhận đã được gửi đi tới số #{@phone_number}."
  end

  def verification_delivery_receipt
    if params["msisdn"]
      @user = User.find_by_phone("#{params["msisdn"].gsub("84","0")}")
      @verification = @user.verifications.where(:status => "UNUSED").first
      @verification.update_attributes :receipt => params
      render :text => "Confirmed."
    else
      render :text => "Error."
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

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to new_user_session_path, alert: "Bạn cần đăng nhập để tiếp tục."
      end
    end
end