require 'social_share'

class ProjectUpdatesController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]
  layout "layouts/dashboard", except: [:index, :show]

  def index
    @project = Project.find(params[:project_id])
    @project_updates = @project.project_updates
    render layout: "layouts/item-based"
  end

  def new
    @project = Project.find(params[:project_id])
    if (!signed_in?) || ((current_user) && (!@project.belongs_to?(current_user)))
      redirect_to @project, alert: "Permission denied."
    elsif @project.status == "FINISHED" || @project.status == "REVIEWED"
      new!
    else # outdated projects
      redirect_to edit_project_path(@project), alert: "Permission denied."
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @project_update = ProjectUpdate.new(params[:project_update])
    if @project_update.save
      @token = RedirectToken.create(redirect_class_name: "ProjectUpdate", redirect_class_id: @project_update.id)
      @project.project_follows.each do |pf|
        UserMailer.delay.send_updates_to_project_followers(@project_update, pf.user)
        SendMessage.notif(uid: pf.user.uid,
          href: "/fbnotif/#{@token.value}",
          template: "#{@project_update.title} (#{@project.title})"
        ) if pf.user.facebook_access_granted?
      end
      @project.donations.successful.each do |donation|
        UserMailer.delay.send_updates_to_project_followers(@project_update, donation.user)
        SendMessage.notif(uid: donation.user.uid,
          href: "/fbnotif/#{@token.value}",
          template: "#{@project_update.title} (#{@project.title})"
        ) if donation.user.facebook_access_granted?
      end
      respond_to do |format|
        format.json { render :json => @project_update }
        format.html { redirect_to project_project_updates_path(@project), notice: "Vừa thêm Cập nhật dự án mới." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end

  def show
    @project = Project.find(params[:project_id])
    @user = @project.user
    @project_update = @project.project_updates.where(:id => params[:id]).first
    render layout: "layouts/item-based"
  end
end
