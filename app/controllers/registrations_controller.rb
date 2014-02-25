require 'ga_api'

class RegistrationsController < Devise::RegistrationsController
  include DonationsHelper
  include GiftCardsHelper
  before_filter :validate_gift_card_token

  def new
    if params[:token]
      @token = Token.find_by_value params[:token]
      @ext_donation = @token.ext_donation if @token && !@token.used?
    end
    super
  end

  def create
    build_resource(sign_up_params)
    if resource.save
      if params[:token]
        @token = Token.find_by_value params[:token]
        create_donation_from_ext(resource, @token.ext_donation) if !@token.used?
      end
      if params[:card_token] && (@gift_card = GiftCard.find_by(token: params[:card_token].upcase))
        @gift_card.redeem(resource)
      end
      GoogleAnalyticsApi.event("SignUp", "Successful", params[:ga_client_id]) if params[:ga_client_id]
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private
    def validate_gift_card_token
      if params[:card_token] && !(@gift_card = GiftCard.find_by(token: params[:card_token].upcase))
        redirect_to gifts_path, alert: "Mã không hợp lệ."
      end
    end
end