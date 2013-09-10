require 'sms'

class UsersController < ApplicationController

  before_filter :authenticate_user!, except: :profile

  def dashboard
    
  end

  def profile
    @user = User.find(params[:id]) || current_user
  end

  def settings
  	@user = current_user
  end

  def update_settings
  	@user = User.find(params[:user][:id])
  	if @user.update params[:user]
  		redirect_to users_settings_path
      flash[:notice] = "Updated Successfully."
  	else
  		render :action => :settings
      flash[:alert] = "Unsuccessful Update."
  	end
  end

  def verification_code_via_phone
    if params[:phone_number]
      @phone_number = params[:phone_number].gsub(/\D/, '').to_i.to_s
      @verification = Verification.new(user_id: current_user.id)
      if @verification.save
        sms = SMS.send(@phone_number, "Ma so danh cho viec xac nhan danh tinh tai charity-map.org: #{@verification.code}") # if Rails.env.production?
        if sms
          current_user.update(phone: @phone_number) if current_user.phone.blank?  
          redirect_to users_settings_path, notice: "Mã xác nhận vừa được gửi tới số +84#{@phone_number}. Mời bạn điền mã vào ô dưới để hoàn tất quá trình xác nhận."
        else
          redirect_to users_settings_path, notice: "Gửi tin nhắn không thành công. Vui lòng kiểm tra lại số điện thoại, không thêm mã quốc gia và quốc tế vào."
        end
      else
        redirect_to users_settings_path, alert: "Errors occurred. Please try again later."
      end
    elsif params[:phone_code]
      @verification = Verification.where(user_id: current_user.id, code: params[:phone_code], status: "UNUSED").first
      unless current_user.verified_by_phone
        current_user.update verified_by_phone: true
        @verification.update status: "USED"
        redirect_to users_settings_path, notice: "Xác nhận danh tính bằng số điện thoại hoàn tất."
      else
        redirect_to users_settings_path, alert: "Permission denied."
      end
    end
  end

end