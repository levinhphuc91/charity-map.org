class AddProjectIdToInvites < ActiveRecord::Migration
  def change
    add_reference :invites, :project, index: true
  end
end
