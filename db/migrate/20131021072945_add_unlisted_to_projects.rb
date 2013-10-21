class AddUnlistedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :unlisted, :boolean
  end
end
