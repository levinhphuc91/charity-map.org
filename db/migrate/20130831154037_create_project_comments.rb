class CreateProjectComments < ActiveRecord::Migration
  def change
    create_table :project_comments do |t|
      t.text :content
      t.references :user, index: true
      t.references :project, index: true

      t.timestamps
    end
  end
end
