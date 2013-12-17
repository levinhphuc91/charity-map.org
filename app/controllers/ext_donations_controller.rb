class ExtDonationsController < InheritedResources::Base
  nested_belongs_to :project
  before_filter :authenticate_user!
  layout "layouts/dashboard"

  def create
    create! { project_donations_url(@project) }
  end
  
  def update
    update! { project_donations_url(@project) }
  end

  def destroy
    destroy! { project_donations_url(@project) }
  end
end
