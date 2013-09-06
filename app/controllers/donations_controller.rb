class DonationsController < InheritedResources::Base
  include DonationsHelper
  before_filter :authenticate_user!

  def index
    render nothing: true
  end

  def new
    @project = Project.find(params[:project_id])
    new!
  end

  def create
    @project = Project.find(params[:project_id])
    unless @project.accepting_donation?
      redirect_to @project, notice: "Dự án này hiện đang không gây quỹ. Vui lòng thử lại sau."
    else
      @donation = Donation.new(params[:donation])
      @donation.project_reward_id = auto_select_project_reward(@project, params[:donation][:amount])
      if @donation.save
        redirect_to @project, notice: "Cảm ơn bạn đã ủng hộ dự án! Vui lòng check email để nhận biên nhận hoặc thông tin chi tiết."
      else
        render :new, notice: "Không thành công. Vui lòng thử lại."
      end
    end
  end

  def request_verification
    @donation = Donation.find(params[:id])
    if current_user.donations.exists?(@donation) && @donation.collection_method == "BANK_TRANSFER" && @donation.status == "PENDING"
      @donation.update status: "REQUEST_VERIFICATION"
      # UserMailer.gui email den project creator
    end
  end
end
