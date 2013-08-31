class UsersController < ApplicationController

  before_filter :authenticate_user!

  def dashboard
  end

  def profile
  end

  def settings
  end
end
