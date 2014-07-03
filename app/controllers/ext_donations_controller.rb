class ExtDonationsController < InheritedResources::Base
  nested_belongs_to :project
  before_filter :authenticate_user!
  before_filter :restricted_access
  layout "layouts/dashboard"

  def create
    create! do |success, failure|
      success.html {
        UserMailer.delay.invite_ext_donor(@ext_donation) if params[:notification] == "true" && !@ext_donation.email.blank?
        redirect_to project_donations_url(@project), notice: t('controller.ext_donations.create_successfully')
      }
      failure.html { redirect_to project_donations_url(@project), alert: "#{@ext_donation.errors.full_messages.join(', ')}" }
    end
  end
  
  def update
    update!(notice: t('controller.ext_donations.update_successfully')) { project_donations_url(@project) }
  end

  def destroy
    destroy!(notice: t('controller.ext_donations.delete_successfully')) { project_donations_url(@project) }
  end

  private
    def restricted_access
      @project = Project.find(params[:project_id])
      unless @project.authorized_edit_for?(current_user)
        redirect_to :root, alert: t('common.permission_denied')
      end
    end
end
