class RenameThumbnailInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :thumbnail, :photo
  end
end
