require 'sms'
require 'social_share'
require 'charitio'

class UsersController < ApplicationController
  include SessionsHelper
  include GiftCardsHelper
  prepend_before_filter :authenticate_user!, except: [:profile, :verification_delivery_receipt, :fbnotif]
  before_filter :connect_backend_api, except: [:profile, :verification_delivery_receipt, :fbnotif]
  layout "layouts/dashboard", only: [
    :dashboard, :settings, :messages, :donations, :gift_cards, :update_settings,
    :verify, :show_message, :new_message, :new_reply_message
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
      redirect_to user_profile_path(@followed), notice: t("controller.users.follow_successfully")
    else
      redirect_to user_profile_path(@followed), alert: t("controller.users.follow_unsuccessfully")
    end
  end

  def settings
  	@user = current_user
  end

  def donations
  end

  def gift_cards
    @gift_cards = GiftCard.where(recipient_email: current_user.email)
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
      flash[:notice] = t("controller.users.update_successfully")
  	else
  		render :action => :settings, alert: t("controller.users.update_failed_with_errors", :errors => @user.errors.full_messages.join)
  	end
  end

  def add_figure_to_portfolio
    if params[:key].blank? || params[:value].blank?
      redirect_to users_profile_path, alert: t("controller.users.update_failed")
    else
      figures = (current_user.figures || {}).merge({"#{params[:key].html_safe}" => "#{params[:value].html_safe}"})
      if current_user.update_attributes :figures => figures
        redirect_to users_profile_path, notice: t("controller.users.update_successfully")
      else
        redirect_to users_profile_path, alert: t("controller.users.update_failed")
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
      redirect_to users_profile_path, alert: t("controller.users.update_failed")
    end
  end

  def add_ext_project_to_portfolio
    @ext_project = ExtProject.new(params[:ext_project])
    if @ext_project.save
      redirect_to users_profile_path, notice: t("controller.users.update_successfully")
    else
      redirect_to users_profile_path, alert: t("controller.users.update_failed")
    end
  end

  def delete_ext_project_from_portfolio
    @ext_project = ExtProject.find(params[:ext_project])
    if (@ext_project.user == current_user) && @ext_project.destroy!
      redirect_to users_profile_path, notice: t("controller.users.delete_project_successfully")
    else
      redirect_to users_profile_path, alert: t("controller.users.delete_project_failed")
    end
  end

  def verification_code_via_phone
    if params[:phone_number]
      @phone_number = params[:phone_number].gsub(/\D/, '').to_i.to_s
      @verification = Verification.new(user_id: current_user.id)
      if @verification.save
        sms = SMS.send(to: @phone_number, text: t("controller.users.verification_code", :code => @verification.code)) if Rails.env.production?
        @verification.update status: sms
        current_user.update(phone: @phone_number) if current_user.phone.blank?  
        redirect_to users_verify_path, notice: t("controller.users.enter_verification_code", :phone_number => @phone_number)
      else
        redirect_to users_verify_path, alert: t("common.failed_and_try_again")
      end
    elsif params[:phone_code]
      @verification = current_user.verification
      unless current_user.verified_by_phone
        current_user.update verified_by_phone: true
        @verification.update status: "USED"
        redirect_to users_verify_path, notice: t("controller.users.verify_completely")
      else
        redirect_to users_verify_path, alert: t("common.permission_denied")
      end
    end
  end

  def resend_verification
    @phone_number = current_user.phone.gsub(/\D/, '').to_i.to_s
    @verification = current_user.verification
    if @verification.status == "UNUSED"
      @sms = SMS.send(to: @phone_number, text: t("controller.users.verification_code", :code => @verification.code)) # if Rails.env.production?
      @verification.update status: @sms
    end
    redirect_to users_verify_path, notice: t("controller.users.enter_verification_code", :phone_number => @phone_number)
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
    redirect_to :dashboard, notice: t("controller.users.delivered_message")
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
    redirect_to :dashboard, notice: t("controller.users.delivered_message")
  end
  
  def fbnotif
    if params[:token] && (@token = RedirectToken.find_by_value(params[:token]))
      @url = redirect_via_token @token
    else
      @url = root_url
    end
  end

  def redeem_gift_card
    @gift_card = GiftCard.find_by(token: params[:card_token].upcase) if params[:card_token]
    if @gift_card
      if @gift_card.redeem(@user)
        redirect_to users_gift_cards_path, notice: t("controller.users.gift_card_redeem", :amount => @gift_card.amount)
      else
        redirect_to gifts_path, alert: t("controller.users.error_gift_card")
      end
    else
      redirect_to gifts_path, alert: t("controller.users.invalid_gift_card")
    end
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to new_user_session_path, alert: t("controller.users.login_to_continue")
      end
    end

    def allow_facebook_iframe
      response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
    end

    def connect_backend_api
      if user_signed_in? && (@user = current_user)
        @charitio = Charitio.new(@user.email, @user.api_token || "")
        if @user.api_token.blank?
          @workoff = @charitio.create_user(email: @user.email, category: "INDIVIDUAL")
          if @workoff.ok?
            @user.update_attribute :api_token, @workoff.response["auth_token"]
          else
            redirect_to dashboard_path, alert: t("controller.users.api_failed")
            Honeybadger.notify(error_message: %Q{\
              [#{Time.zone.now}][User#connect_backend_api Charitio.create_user] \
                Affected user: #{@user.id} / Truncated email: #{@user.email.split('@').first} \
                API response: #{@workoff.response} \
              })
          end
        end
      end
    end
end
