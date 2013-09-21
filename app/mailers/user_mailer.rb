class UserMailer < ActionMailer::Base
  default from: "tu@charity-map.org"
  helper :application

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

  def project_follow_update(project_update)
    @project_update = project_update
    @project = project_update.project
    project_follows = @project.project_follows
    project_follows.each do |pf|
      @user = pf.user
      mail(to: @user.email, subject: "Dự án #{@project.title} có cập nhật mới")
    end    
  end

  def remind_follower_before_5_days(project)
    @project = project
    project_follows = @project.project_follows
    project_follows.each do |pf|
      @user = pf.user
      mail(to: @user.email, subject: "Dự án #{@project.title} còn 5 ngày để gây quỹ")
    end
  end
end
