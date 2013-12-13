class AddInviteContentToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :invite_email_content, :text
    add_column :projects, :invite_sms_content, :string
  end
end
