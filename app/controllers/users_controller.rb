class UsersController < ApplicationController

  before_filter :authenticate_user!

  def dashboard
    
  end

  def profile
  end

  def settings
  	@user = current_user
  end

  def update_settings
  	@user = User.find(params[:user][:id])
  	if @user.update_attributes params[:user]
  		redirect_to users_settings_path
      flash[:notice] = "Updated Successfully."
  	else
  		render :action => :settings
      flash[:notice] = "Unsuccessful Update."
  	end
  end

end