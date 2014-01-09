class ProjectsController < InheritedResources::Base
  include SessionsHelper
  before_filter :authenticate_user!, except: [:index, :show, :search, :autocomplete, :abbr]
  before_filter :restricted_access, only: [:submit, :edit]
  impressionist actions: [:show]

  def index
    if params[:filter] && params[:filter] == "funding"
      @projects = Project.funding
    elsif params[:filter] == "finished"
      @projects = Project.finished
    else
      @projects = Project.public_view
    end
    @pending = Project.pending
    @markers = Project.listed.mapped
  end

  def new
    @project = Project.new
    if current_user.blank_contact?
      store_location_with_path(new_project_path)
      redirect_to users_settings_path, notice: "Phiền bạn cập nhật đầy đủ tên họ và địa chỉ trước khi tạo dự án."
    else 
      render layout: "layouts/dashboard2"
    end
  end

  def create
    create! do |success, failure|
      failure.html { render layout: "layouts/dashboard2" }
    end
  end

  def show
    @project = Project.find(params[:id])
    @user = @project.user
    @project_follow = ProjectFollow.new
    if(current_user)
      @followed_project = (ProjectFollow.find_by_project_id_and_user_id(@project.id, current_user.id)) != nil ? true : false
    end
    if @project.status == "DRAFT" || @project.status == "PENDING"
      if (!signed_in?) || ((current_user) && (!@project.belongs_to?(current_user)) && (!current_user.staff))
        redirect_to pages_home_path, alert: "Permission denied."
      end
    end
    render layout: "layouts/item-based"
  end

  def edit
    render layout: "layouts/dashboard2"
  end

  def update
    update!(notice: "Cập nhật dự án thành công.") { params[:href] if params[:href] }
  end

  def submit
    if @project.project_rewards.empty?
      redirect_to project_project_rewards_path(@project), alert: "Phải có ít nhất một Đề mục đóng góp (project reward)."
    else
      if @project.update_attributes(status: "REVIEWED")
        redirect_to @project, notice: "Dự án chuyển sang trạng thái gây quỹ."
        AdminMailer.delay.new_pending_project(@project) if @project.status == "REVIEWED"
      end
    end
  end

  def search
    @project = Project.find_by_title(params[:query])
    redirect_to @project
  end

  def autocomplete
    render json: Project.public_view.map(&:title)
  end

  def abbr
    @project = Project.find_by_short_code(params[:short_code])
    if @project
      redirect_to @project
    else
      redirect_to root_path
    end
  end

  def invite_ext_donor
    @ext_donation = ExtDonation.find params[:ext_donation_id]
    UserMailer.delay.invite_ext_donor(@ext_donation) unless @ext_donation.email.blank?
    redirect_to project_donations_path(@ext_donation.project)
  end

  private
    def restricted_access
      @project = Project.find(params[:id])
      redirect_to :root, alert: "Permission denied." if !signed_in? || !@project.authorized_edit_for?(current_user)
    end
end
