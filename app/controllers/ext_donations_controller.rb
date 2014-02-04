class ExtDonationsController < InheritedResources::Base
  nested_belongs_to :project
  before_filter :authenticate_user!
  before_filter :restricted_access
  layout "layouts/dashboard"

  def create
    create! do |success, failure|
      success.html {
        UserMailer.delay.invite_ext_donor(@ext_donation) if params[:notification] == "true" && !@ext_donation.email.blank?
        redirect_to project_donations_url(@project), notice: "Thêm ủng hộ ngoài hệ thống thành công."
      }
      failure.html { redirect_to project_donations_url(@project), alert: "#{@ext_donation.errors.full_messages.join(', ')}" }
    end
  end
  
  def update
    update!(notice: "Sửa ủng hộ ngoài hệ thống thành công.") { project_donations_url(@project) }
  end

  def destroy
    destroy!(notice: "Đã xoá ủng hộ ngoài hệ thống.") { project_donations_url(@project) }
  end

  private
    def restricted_access
      @project = Project.find(params[:project_id])
      unless @project.authorized_edit_for?(current_user)
        redirect_to :root, alert: "Permission denied."
      end
    end
end
