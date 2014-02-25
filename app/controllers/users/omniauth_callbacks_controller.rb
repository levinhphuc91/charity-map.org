require 'ga_api'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include DonationsHelper
  include GiftCardsHelper

  def facebook
    @auth = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(@auth.provider, @auth.uid, @auth.credentials, @auth.info.email, current_user)

    # @user.fetch_fb_friends
    @extra_params = request.env["omniauth.params"]
    if @extra_params && !@extra_params["token"].blank?
      @token = Token.find_by_value(@extra_params["token"])
      create_donation_from_ext(@user, @token.ext_donation) if @token && !@token.used?
    end

    if @extra_params && !@extra_params["card_token"].blank?
      @gift_card = GiftCard.find_by(token: @extra_params["card_token"])
      @gift_card.redeem(@user) if @gift_card
    end

    if (@user.created_at > Time.now.beginning_of_day)
      GoogleAnalyticsApi.event("SignUp", "Successful", @extra_params["ga_client_id"])
    end

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      # session["devise.facebook_data"] = @auth
      redirect_to new_user_registration_url
    end
  end

end