class AddPhotoToProjectUpdates < ActiveRecord::Migration
  def change
    add_column :project_updates, :photo, :string
  end
end
