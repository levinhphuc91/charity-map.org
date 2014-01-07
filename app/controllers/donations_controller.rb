class DonationsController < InheritedResources::Base
  include DonationsHelper
  include SessionsHelper
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @project = Project.find(params[:project_id])
    @donations = (current_user && @project.authorized_edit_for?(current_user)) ? @project.donations.order("date(updated_at) DESC") : @project.donations.successful.order("date(updated_at) DESC")
    @donations = sort_donations(@donations, params[:sort_by]) if (params[:sort_by])
    @ext_donation = ExtDonation.new
    @ext_donations = @project.ext_donations
    @max = (@project.donations_sum > @project.funding_goal ? @project.donations_sum + 10000000 : @project.funding_goal)
    render layout: "layouts/item-based"
  end

  def show
    @donation = Donation.find(params[:id])
    @project = @donation.project
    show!
  end
  
  def new
    @project = Project.find(params[:project_id])
    if current_user.blank_contact?
      store_location_with_path(params[:project_reward_id] ? new_project_donation_path(@project, project_reward_id: params[:project_reward_id]) : new_project_donation_path(@project))
      redirect_to users_settings_path, notice: "Vui lòng điền đầy đủ thông tin liên hệ trước khi ủng hộ dự án #{@project.title}"
    else
      if @project.accepting_donations?
        if @project.item_based
          @project_reward = ProjectReward.find(params[:project_reward_id])
        end
        @donation = Donation.new
        render layout: "layouts/item-based"
      else
        redirect_to @project, alert: "Dự án này hiện đang không gây quỹ. Vui lòng thử lại sau."
      end
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = Donation.new(params[:donation])
    if @donation.save
      if @donation.collection_method == "BANK_TRANSFER"
        UserMailer.delay.bank_account_info(@donation)
        redirect_to @project, notice: "Cảm ơn bạn đã ủng hộ dự án! Vui lòng check email để nhận thông tin tài khoản ngân hàng để tiến hành chuyển khoản."
      elsif @donation.collection_method == "COD"
        redirect_to @project, notice: "Cảm ơn bạn đã ủng hộ dự án! Chúng tôi sẽ liên hệ trong 3 ngày làm việc."
      else
        redirect_to @project, notice: "Cảm ơn bạn đã ủng hộ dự án!"
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end

  def request_verification
    @donation = Donation.find_by_euid(params[:euid])
    if @donation && @donation.belongs_to?(current_user) && @donation.status == "PENDING" && @donation.collection_method == "BANK_TRANSFER"
      @donation.update status: "REQUEST_VERIFICATION"
      UserMailer.delay.bank_transfer_request_verification(@donation)
      redirect_to :dashboard, notice: "Yêu cầu tra soát hệ thống đã được gửi. Chúng tôi sẽ liên lạc trong thời gian sớm nhất."
    else
      redirect_to :dashboard, alert: "Permission denied."
    end
  end

  def confirm
    require 'social_share'
    @donation = Donation.find_by_euid(params[:euid])
    if (@donation.project.authorized_edit_for?(current_user) && @donation.status != "SUCCESSFUL")
      @donation.update_attributes status: "SUCCESSFUL"
      if (@donation.collection_method == "BANK_TRANSFER")
        UserMailer.delay.bank_transfer_confirm_donation(@donation)
        SendMessage.delay.fb({
          :link => "http://www.charity-map.org#{project_path(@donation.project)}",
          :message => "#{@donation.user.name} vừa ủng hộ #{@donation.amount.to_i}đ cho dự án #{@donation.project.title}"}, @donation.user
        ) if (@donation.user.provider == "facebook" && Rails.env.production?)
      elsif (@donation.collection_method == "COD")
        UserMailer.delay.cod_confirm_donation(@donation)
        SendMessage.delay.fb({
          :link => "http://www.charity-map.org#{project_path(@donation.project)}",
          :message => "#{@donation.user.name} vừa ủng hộ #{@donation.amount.to_i}đ cho dự án #{@donation.project.title}"}, @donation.user
        ) if (@donation.user.provider == "facebook" && Rails.env.production?)
      end
      redirect_to project_donations_path(@donation.project), notice: "Xác nhận thành công. Email vừa được gửi tới mạnh thường quân thông báo bạn đã nhận được tiền."
    else
      redirect_to dashboard_path
    end
  end
end
