class DonationsController < InheritedResources::Base

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
end
