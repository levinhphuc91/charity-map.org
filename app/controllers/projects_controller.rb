class ProjectsController < InheritedResources::Base
  include SessionsHelper
  before_filter :authenticate_user!, except: [:index, :show, :search, :autocomplete, :abbr]
  before_filter :restricted_access, only: :submit
  # impressionist actions: [:show]

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
      redirect_to users_settings_path, notice: I18n.t('user_blank_contact', :scope => ['controller','project'])
    else 
      new!
    end
  end

  def show
    @project = Project.find(params[:id])
    @donation = Donation.find(params[:cid]) if params[:cid]
    if params[:token]
      @token = Token.find_by_value params[:token]
      @ext_donation = @token.ext_donation if @token && !@token.used?
    end
    @user = @project.user
    @project_follow = ProjectFollow.new
    if @project.status == "DRAFT" || @project.status == "PENDING"
      if (!signed_in?) || ((current_user) && (!@project.belongs_to?(current_user)) && (!current_user.staff))
        redirect_to(pages_home_path, alert: I18n.t('permission_denied', :scope => ['errors','messages'])) and return
      end
    end
    render layout: "layouts/item-based"
  end

  def edit
    @project = Project.find(params[:id])
    if @project.belongs_to?(current_user)
      edit!
    else
      redirect_to :dashboard, alert: I18n.t('permission_denied', :scope => ['errors','messages'])
    end
  end

  def update
    update!(notice: I18n.t('update_successful', :scope => ['controller','project'])) { params[:href] if params[:href] }
  end

  def submit
    if @project.project_rewards.empty?
      redirect_to project_project_rewards_path(@project), alert: I18n.t('title_required', :scope => ['controller','project'], :project_rewards => @project_rewards)
    else
      if @project.update_attributes(status: "REVIEWED")
        redirect_to @project, notice: I18n.t('funding_state_project', :scope => ['controller','project'])
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
      redirect_to :root, alert: I18n.t('permission_denied', :scope => ['errors','messages']) if !signed_in? || !@project.authorized_edit_for?(current_user)
    end
end
