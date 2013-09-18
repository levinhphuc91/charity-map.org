class DonationsController < InheritedResources::Base
  include DonationsHelper
  before_filter :authenticate_user!, except: [:index, :show]

  def show
    @donation = Donation.find(params[:id])
    @project = @donation.project
    show!
  end
  
  def new
    @project = Project.find(params[:project_id])
    if current_user.blank_contact?
      redirect_to users_settings_path, notice: "Vui lòng điền đầy đủ thông tin liên hệ trước khi ủng hộ dự án #{@project.title}"
    else
    # TODO: viet test, add redirect_back
      if @project.accepting_donation?
        new!
      else
        redirect_to @project, alert: "Dự án này hiện đang không gây quỹ. Vui lòng thử lại sau."
      end
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = Donation.new(params[:donation])
    @donation.project_reward_id = auto_select_project_reward(@project, params[:donation][:amount])
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
    if (current_user.donations.exists?(@donation) != nil) && @donation && @donation.status == "PENDING" && @donation.collection_method == "BANK_TRANSFER"
      @donation.update status: "REQUEST_VERIFICATION"
      UserMailer.delay.bank_transfer_request_verification(@donation)
      redirect_to :dashboard, notice: "Yêu cầu tra soát hệ thống đã được gửi. Chúng tôi sẽ liên lạc trong thời gian sớm nhất."
    else
      redirect_to :dashboard, alert: "Permission denied."
    end
  end
end
