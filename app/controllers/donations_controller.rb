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
    @donation = Donation.find(params[:cid]) if params[:cid]
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
      redirect_to users_settings_path, notice: t("controller.donations.blank_contact_notice", :project_title => @project.title)
    else
      if @project.accepting_donations?
        if @project.item_based
          @project_reward = ProjectReward.find(params[:project_reward_id])
          redirect_to @project, alert: t('controller.donations.at_least_one_reward') if !@project_reward
        end
        @donation = Donation.new
      else
        redirect_to @project, alert: t('controller.donations.not_funding_project')
      end
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = Donation.new(params[:donation])
    if @donation.save
      if @donation.sent_via?("BANK_TRANSFER")
        UserMailer.delay.bank_account_info(@donation)
        @notice = t('controller.donations.bank_transfer_confirm')
      elsif @donation.sent_via?("COD")
        @notice = t('controller.donations.cod_confirm')
      elsif @donation.sent_via?("CM_CREDIT")
        if @donation.confirm!
          UserMailer.delay.confirm_cm_credit_donation(@donation)
          @notice = t('controller.donations.credit_cofirm')
        else
          @notice = t('controller.donations.credit_error')
        end
      end
      redirect_to project_donations_path(@project, cid: @donation.id), notice: @notice
    else
      @project_reward = ProjectReward.find(params[:donation][:project_reward_id])
      render :new, alert: t('common.failed_and_try_again')
    end
  end

  def check_balance
    @donation = Donation.new(params[:donation])
    if @donation.sent_via?("CM_CREDIT") && (@donation.amount > balance(current_user))
      if @donation.project.item_based
        redirect_to project_path(@donation.project), alert: t('controller.donations.not_enough_balance')
      else
        redirect_to new_project_donation_path(@donation.project), alert: t('controller.donations.not_enough_balance')
      end
    end
  end

  def request_verification
    @donation = Donation.find_by_euid(params[:euid])
    if @donation && @donation.belongs_to?(current_user) && @donation.status == "PENDING" && @donation.collection_method == "BANK_TRANSFER"
      @donation.update status: "REQUEST_VERIFICATION"
      UserMailer.delay.bank_transfer_request_verification(@donation)
      redirect_to :dashboard, notice: t('controller.donations.request_verification')
    else
      redirect_to :dashboard, alert: t('common.permission_denied')
    end
  end

  def confirm
    @donation = Donation.find_by_euid(params[:euid])
    if (@donation.project.authorized_edit_for?(current_user) && @donation.status != "SUCCESSFUL")
      if @donation.confirm!
        @token = RedirectToken.create(redirect_class_name: "Donation", redirect_class_id: @donation.id)
        @donor = @donation.user
        if (@donation.collection_method == "BANK_TRANSFER")
          UserMailer.delay.bank_transfer_confirm_donation(@donation) if @donor.notify_via_email
          SMS.send(
            to: phone_striped(@donor.phone), 
            text: "(Charity Map) Ung ho ma so #{params[:euid]} (VND#{@donation.amount.to_i}) vua duoc du an xac nhan. Chan thanh cam on quy MTQ. charity-map.org"
          ) if (!@donor.phone.blank? && @donor.notify_via_sms)
          # SendMessage.fb({
          #   :link => "http://www.charity-map.org#{project_path(@donation.project)}?utm_campaign=WallPostOnDonation",
          #   :name => "#{@donation.project.title}",
          #   :picture => "#{@donation.project.photo_url(:banner)}",
          #   :description => "#{@donation.project.brief}",
          #   :message => "#{@donor.name} vừa ủng hộ #{@donation.amount.to_i}đ cho dự án #{@donation.project.title}"}, @donor
          # ) if (@donor.facebook_access_granted? && Rails.env.production?)
          SendMessage.notif(uid: @donor.uid,
            href: "/fbnotif/#{@token.value}",
            template: "Ủng hộ số #{@donation.euid} cho dự án #{@donation.project.title} vừa được xác nhận."
          ) if (@donor.facebook_access_granted? && @donor.notify_via_facebook)
        elsif (@donation.collection_method == "COD")
          UserMailer.delay.cod_confirm_donation(@donation)
          SMS.send(
            :to => phone_striped(@donor.phone),
            :text => "(Charity Map) Ung ho ma so #{params[:euid]} (VND#{@donation.amount.to_i}) vua duoc du an xac nhan. Chan thanh cam on quy MTQ. charity-map.org"
          ) if (!@donor.phone.blank? && @donor.notify_via_sms)
          # SendMessage.fb({
          #   :link => "http://www.charity-map.org#{project_path(@donation.project)}?utm_campaign=WallPostOnDonation",
          #   :name => "#{@donation.project.title}",
          #   :description => "#{@donation.project.brief}",
          #   :picture => "#{@donation.project.photo_url(:banner)}",
          #   :message => "#{@donor.name} vừa ủng hộ #{@donation.amount.to_i}đ cho dự án #{@donation.project.title}"}, @donor
          # ) if (@donor.facebook_access_granted? && Rails.env.production?)
          SendMessage.notif(uid: @donor.uid,
            href: "/fbnotif/#{@token.value}",
            template: "Ủng hộ số #{@donation.euid} cho dự án #{@donation.project.title} vừa được xác nhận."
          ) if (@donor.facebook_access_granted? && @donor.notify_via_facebook)
        end
        redirect_to project_donations_path(@donation.project), notice: t('controller.donations.succefful_verification')
      else
        redirect_to project_donations_path(@donation.project), notice: t('common.failed_and_try_again')
      end
    else
      redirect_to dashboard_path
    end
  end
end