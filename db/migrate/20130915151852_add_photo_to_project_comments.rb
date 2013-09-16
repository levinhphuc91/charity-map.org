class AddPhotoToProjectComments < ActiveRecord::Migration
  def change
    add_column :project_comments, :photo, :string
  end
end
