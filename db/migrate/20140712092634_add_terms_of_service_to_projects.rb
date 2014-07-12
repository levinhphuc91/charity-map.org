class AddTermsOfServiceToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :terms_of_service, :boolean
  end
end
