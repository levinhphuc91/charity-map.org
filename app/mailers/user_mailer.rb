class UserMailer < ActionMailer::Base
  default from: "tu@charity-map.org"
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
