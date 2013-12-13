class InvitesController < InheritedResources::Base
  nested_belongs_to :project
  before_filter :authenticate_user!
  layout "layouts/dashboard"

  def index
    @invite = Invite.new
    index!
  end

  def create
    @invite = Invite.create params[:invite]
    respond_to do |format|
      format.js
    end
    # create! { project_invites_url(@project) }
  end

  def update
    update! { project_invites_url(@project) }
  end

  def send_out
    @project = Project.find_by_slug(params[:project_id])
    if @project.invite_email_content.blank? || @project.invite_sms_content.blank?
      redirect_to action: :index
      flash[:alert] = "Nội dung thư mời chưa đầy đủ."
    elsif params[:all]
      @project.invites.fresh.each do |invite|
      end
    elsif params[:id]
      @invite = Invite.find params[:id]
    end
  end
end
