class ProjectsController < InheritedResources::Base
  include SessionsHelper
  before_filter :authenticate_user!, except: [:index, :show, :search, :autocomplete]

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
      new!
    end
  end

  def show
    @project = Project.find(params[:id])
    @user = @project.user
    @new_comment = ProjectComment.new
    @project_follow = ProjectFollow.new
    if(current_user)
      @followed_project = (ProjectFollow.find_by_project_id_and_user_id(@project.id, current_user.id)) != nil ? true : false
    end
    if @project.status == "DRAFT" || @project.status == "PENDING"
      if (!signed_in?) || ((current_user) && (!@project.belongs_to?(current_user)) && (!current_user.staff))
        redirect_to pages_home_path, alert: "Permission denied."
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
    if @project.belongs_to?(current_user)
      edit!
    else
      redirect_to :dashboard, alert: "Permission denied."
    end
  end

  def update
    update!
  end

  def submit
    @project = Project.find(params[:id])
    if current_user && @project.belongs_to?(current_user) && @project.status == "DRAFT"
      if @project.project_rewards.empty?
        redirect_to edit_project_path(@project), alert: "Phải có ít nhất một Đề mục đóng góp (project reward)."
      else
        if @project.update status: "PENDING"
          redirect_to @project, notice: "Chúng tôi đã nhận được thông tin dự án của bạn và sẽ liên lạc trong thời gian sớm nhất."
          AdminMailer.delay.new_pending_project(@project)
        else
          redirect_to edit_project_path(@project), alert: "#{@project.errors.full_messages.join(' ')}"
        end
      end
    else
      redirect_to :dashboard, alert: "Permission denied"
    end
  end

  def search
    @project = Project.find_by_title(params[:query])
    redirect_to @project
  end

  def autocomplete
    render json: Project.public_view.map(&:title)
  end
end
