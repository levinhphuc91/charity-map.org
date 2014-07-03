class Admin::PagesController < ApplicationController
  before_filter :http_authenticate
  before_filter :authenticate_user!

  def projects
    @projects = Project.all.order("created_at DESC")
  end

  def donations
    if params[:id] && project = Project.find(params[:id])
      @donations = @project.donations.order("created_at DESC")
      @ext_donations = @project.ext_donations.order("created_at DESC")
    else
      @donations = Donation.all.order("created_at DESC")
      @ext_donations = ExtDonation.all.order("created_at DESC")
    end
  end

  def users
    @users = User.all.order("created_at DESC")
  end

  def updates
    @updates = ProjectUpdate.all
  end

  def edit_donation
    @donation = Donation.find params[:id]
  end

  def update_donation
    @donation = Donation.find params[:id]
    if @donation.update_attributes! params[:donation]
      redirect_to admin_pages_donations_path, notice: "Update successful."
    else
      redirect_to admin_pages_edit_donation_path, notice: "Update unsuccessful."
    end
  end

  protected

  def http_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["HTTP_USERNAME"] && password == ENV["HTTP_PASSWORD"]
    end
  end
end
