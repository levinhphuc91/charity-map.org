class UsersController < ApplicationController

  before_filter :authenticate_user!

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

end