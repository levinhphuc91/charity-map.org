class UserMailer < ActionMailer::Base
  default from: "tu@charity-map.org"
  helper :application

  def bank_account_info(donation)
    @donation = donation
    @user = @donation.user
    @project = @donation.project
    mail(to: @user.email, subject: "Thông tin tài khoản NH đóng góp cho dự án #{@project.title}")
  end

  def send_donation_remider(donation)
  	@donation = donation
    @user = donation.user
    mail(to: @user.email, subject: 'Email request verification')
  end

  def email_to_project_creator(donation)
  	@donation = donation
  	@user = User.where(:id => @donation.project.user_id).first;
  	mail(to: @user.email, subject: "Confirm bank statement")
  end

end
