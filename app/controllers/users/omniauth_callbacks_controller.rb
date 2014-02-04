class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include DonationsHelper

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"].provider, request.env["omniauth.auth"].uid, request.env["omniauth.auth"].credentials, request.env["omniauth.auth"].info.email, current_user)
    @user.fetch_fb_friends
    if request.env["omniauth.params"]["token"]
      @token = Token.find_by_value(request.env["omniauth.params"]["token"])
      create_donation_from_ext(@user, @token.ext_donation) if @token && !@token.used?
    end

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end