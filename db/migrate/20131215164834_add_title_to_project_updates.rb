class AddTitleToProjectUpdates < ActiveRecord::Migration
  def change
    add_column :project_updates, :title, :string
  end
end
