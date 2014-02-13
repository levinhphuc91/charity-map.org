class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :reconnect_with_facebook

  def reconnect_with_facebook
    if current_user && current_user.provider == "facebook" && current_user.token_expired?
      redirect_to omniauth_authorize_path(User, "facebook")
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  protected  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
  end

  def set_locale
  	I18n.locale = params[:locale] || I18n.default_locale
	end
end