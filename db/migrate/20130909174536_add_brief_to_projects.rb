class AddBriefToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :brief, :text
  end
end
