class UserMailer < ActionMailer::Base
  default from: "team@charity-map.org"
  helper :application
  include ApplicationHelper
  layout "user_mailer"

  def prefunding_invite(invite)
    @invite = invite
    mail(to: @invite.email, subject: "Đang gây quỹ: Dự án #{@invite.project.title}")
  end

  def bank_account_info(donation)
    @donation = donation
    @user = @donation.user
    @project = @donation.project
    mail(to: @user.email, subject: "Thông tin tài khoản NH đóng góp cho dự án #{@project.title}")
  end

  def bank_transfer_donation_reminder(donation)
  	@donation = donation
    @user = @donation.user
    @project = @donation.project
    mail(to: @user.email, subject: "Tin nhắn: bạn đã chuyển khoản cho dự án #{@project.title}?")
  end

  def bank_transfer_request_verification(donation)
  	@donation = donation
    @project = @donation.project
  	@user = @project.user
  	mail(to: @user.email, subject: "Tin nhắn: Mời xác nhận giao dịch CKNH cho dự án  #{@project.title}")
  end

  def bank_transfer_confirm_donation(donation)
    @donation = donation
    @project = @donation.project
    @user = @donation.user
    mail(to: @user.email, subject: "Xác nhận giao dịch CKNH thành công, dự án #{@project.title}")
  end

  def cod_confirm_donation(donation)
    @donation = donation
    @project = @donation.project
    @user = @donation.user
    mail(to: @user.email, subject: "Xác nhận đã nhận tiền mặt ủng hộ dự án #{@project.title}")
  end

  def send_updates_to_project_followers(project_update, follower)
    @project_update = project_update
    @project = project_update.project
    @follower = follower
    mail(to: follower.email, subject: "Cập nhật mới từ dự án #{@project.title}")
  end

  def remind_followers_5_days_before_end_date(project, follower)
    @project = project
    @follower = follower
    mail(to: @follower.email, subject: "Chiến dịch gây quỹ dự án #{@project.title} sẽ kết thúc trong 5 ngày")
  end

  def invite_ext_donor(ext_donation)
    @ext_donation = ext_donation
    @project = @ext_donation.project
    mail(to: @ext_donation.email, subject: "Cảm ơn bạn đã ủng hộ dự án #{@project.title}")
  end
end