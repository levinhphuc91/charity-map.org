require 'social_share'
require 'uri'

class DonationsController < InheritedResources::Base
  include DonationsHelper
  include SessionsHelper
  include ApplicationHelper
  prepend_before_filter :authenticate_user!, except: [:index, :show]
  before_filter :check_balance, only: :create
  layout "layouts/item-based"

  def index
    @project = Project.find(params[:project_id])
    @donations = (current_user && @project.authorized_edit_for?(current_user)) ? @project.donations.order("date(updated_at) DESC") : @project.donations.successful.order("date(updated_at) DESC")
    @donations = sort_donations(@donations, params[:sort_by]) if (params[:sort_by])
    @ext_donation = ExtDonation.new
    @ext_donations = @project.ext_donations
    @max = (@project.donations_sum > @project.funding_goal ? @project.donations_sum + 10000000 : @project.funding_goal)
  end

  def show
    @donation = Donation.find(params[:id])
    @project = @donation.project
    show!
  end
  
  def new
    @project = Project.find(params[:project_id])
    if current_user.blank_contact?
      store_location_with_path(params[:project_reward_id].blank? ? new_project_donation_path(@project) : new_project_donation_path(@project, project_reward_id: params[:project_reward_id]))
      redirect_to users_settings_path, notice: "Vui lòng điền đầy đủ thông tin cá nhân để ủng hộ dự án #{@project.title} (họ và tên, địa chỉ, số điện thoại)."
    else
      if @project.accepting_donations?
        if @project.item_based
          @project_reward = ProjectReward.find(params[:project_reward_id])
          redirect_to @project, alert: "Bạn phải chọn một trong những tặng phẩm bên dưới." if !@project_reward
        end
        @donation = Donation.new
      else
        redirect_to @project, alert: "Dự án này hiện đang không gây quỹ. Vui lòng thử lại sau."
      end
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = Donation.new(params[:donation])
    if @donation.save
      if @donation.sent_via?("BANK_TRANSFER")
        UserMailer.delay.bank_account_info(@donation)
        @notice = "Cảm ơn bạn đã ủng hộ dự án! Vui lòng check email để nhận thông tin tài khoản ngân hàng để tiến hành chuyển khoản."
      elsif @donation.sent_via?("COD")
        @notice = "Cảm ơn bạn đã ủng hộ dự án! Chúng tôi sẽ liên hệ trong 3 ngày làm việc."
      elsif @donation.sent_via?("CM_CREDIT")
        if @donation.confirm!
          UserMailer.delay.confirm_cm_credit_donation(@donation)
          @notice = "Cảm ơn bạn đã ủng hộ dự án! Vui lòng kiểm tra hòm thư để nhận email xác nhận."
        else
          @notice = "Lỗi phát sinh. Kỹ thuật viên của chúng tôi đã được thông báo."
        end
      end
      redirect_to project_path(@project, cid: @donation.id), notice: @notice
    else
      @project_reward = ProjectReward.find(params[:donation][:project_reward_id])
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end

  def check_balance
    @donation = Donation.new(params[:donation])
    if @donation.sent_via?("CM_CREDIT") && (@donation.amount > balance(current_user))
      if @donation.project.item_based
        redirect_to project_path(@donation.project), alert: "Hiện tài khoản của bạn không đủ số tiền mà bạn muốn ủng hộ."
      else
        redirect_to new_project_donation_path(@donation.project), alert: "Hiện tài khoản của bạn không đủ số tiền mà bạn muốn ủng hộ."
      end
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
    @donation = Donation.find_by_euid(params[:euid])
    if (@donation.project.authorized_edit_for?(current_user) && @donation.status != "SUCCESSFUL")
      if @donation.confirm!
        @token = RedirectToken.create(redirect_class_name: "Donation", redirect_class_id: @donation.id)
        if (@donation.collection_method == "BANK_TRANSFER")
          UserMailer.delay.bank_transfer_confirm_donation(@donation)
          SMS.send(
            to: phone_striped(@donation.user.phone), 
            text: "(Charity Map) Ung ho ma so #{params[:euid]} (VND#{@donation.amount.to_i}) vua duoc du an xac nhan. Chan thanh cam on quy MTQ. charity-map.org"
          ) if (@donation.user.phone)
          SendMessage.fb({
            :link => "http://www.charity-map.org#{project_path(@donation.project)}?utm_campaign=WallPostOnDonation",
            :name => "#{@donation.project.title}",
            :picture => "#{@donation.project.photo_url(:banner)}",
            :description => "#{@donation.project.brief}",
            :message => "#{@donation.user.name} vừa ủng hộ #{@donation.amount.to_i}đ cho dự án #{@donation.project.title}"}, @donation.user
          ) if (@donation.user.facebook_access_granted? && Rails.env.production?)
          SendMessage.notif(uid: @donation.user.uid,
            href: "/fbnotif/#{@token.value}",
            template: "Ủng hộ số #{@donation.euid} cho dự án #{@donation.project.title} vừa được xác nhận."
          ) if @donation.user.facebook_access_granted?
        elsif (@donation.collection_method == "COD")
          UserMailer.delay.cod_confirm_donation(@donation)
          SMS.send(
            :to => phone_striped(@donation.user.phone),
            :text => "(Charity Map) Ung ho ma so #{params[:euid]} (VND#{@donation.amount.to_i}) vua duoc du an xac nhan. Chan thanh cam on quy MTQ. charity-map.org"
          ) if (@donation.user.phone)
          SendMessage.fb({
            :link => "http://www.charity-map.org#{project_path(@donation.project)}?utm_campaign=WallPostOnDonation",
            :name => "#{@donation.project.title}",
            :description => "#{@donation.project.brief}",
            :picture => "#{@donation.project.photo_url(:banner)}",
            :message => "#{@donation.user.name} vừa ủng hộ #{@donation.amount.to_i}đ cho dự án #{@donation.project.title}"}, @donation.user
          ) if (@donation.user.facebook_access_granted? && Rails.env.production?)
          SendMessage.notif(uid: @donation.user.uid,
            href: "/fbnotif/#{@token.value}",
            template: "Ủng hộ số #{@donation.euid} cho dự án #{@donation.project.title} vừa được xác nhận."
          ) if @donation.user.facebook_access_granted?
        end
        redirect_to project_donations_path(@donation.project), notice: "Xác nhận thành công. Email vừa được gửi tới mạnh thường quân thông báo bạn đã nhận được tiền."
      else
        redirect_to project_donations_path(@donation.project), notice: "Không thành công. Vui lòng thử lại."
      end
    else
      redirect_to dashboard_path
    end
  end
end