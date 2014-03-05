require 'uri'

class InvitesController < InheritedResources::Base
  nested_belongs_to :project
  before_filter :authenticate_user!
  layout "layouts/dashboard"
  include ApplicationHelper

  def index
    @invite = Invite.new
    index!
  end

  def create
    @invite = Invite.create params[:invite]
    respond_to do |format|
      format.js
    end
    # create! { project_invites_url(@project) }
  end

  def import
    @project = Project.find params[:project_id]
    if params[:import_from] && (@import_from = Project.find(params[:import_from])) && @import_from.authorized_edit_for?(current_user)
      if !@import_from.donations.empty?
        @import_from.donations.each do |donation|
          begin
            @invite = @project.invites.create!(name: donation.user.name, email: donation.user.email, phone: donation.user.phone)
          rescue ActiveRecord::RecordInvalid => rex
            Honeybadger.notify(rex)
          end
        end
      end
      if !@import_from.ext_donations.empty?
        @import_from.ext_donations.each do |donation|
          begin
            @invite = @project.invites.create!(name: donation.donor, email: (donation.email if !donation.email.blank?), phone: (donation.phone if !donation.phone.blank?)) if 
            (!donation.anon) && (!donation.email.blank? || !donation.phone.blank?)
          rescue ActiveRecord::RecordInvalid => rex
            Honeybadger.notify(rex)
          end
        end
      end
      redirect_to project_invites_path(@project), notice: "Thêm liên lạc thành công."
    else
      redirect_to project_invites_path(@project), alert: "Permission denied."
    end
  end

  def update
    update! { project_invites_url(@project) }
  end

  def send_out
    @invite = Invite.find(params[:invite_id])
    if (@invite.project.invite_email_content.blank? || @invite.project.invite_sms_content.blank?)
      redirect_to action: :index
      flash[:alert] = "Nội dung thư mời chưa đầy đủ."
    else
      if (!@invite.phone.blank? && @invite.new?)
        @sms = SMS.send(to: phone_striped(@invite.phone), text: @invite.project.invite_sms_content)
      end
      if (!@invite.email.blank? && @invite.new?)
        UserMailer.prefunding_invite(@invite).deliver
      end
      if @sms
        @invite.update_attributes(status: @sms)
      else
        @invite.update_attributes(status: "SENT")
      end
      redirect_to project_invites_path(@invite.project), notice: "Thư mời đã được gửi đi."
    end
  end
end