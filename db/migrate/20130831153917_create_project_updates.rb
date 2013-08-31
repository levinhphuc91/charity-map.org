class CreateProjectUpdates < ActiveRecord::Migration
  def change
    create_table :project_updates do |t|
      t.text :content
      t.references :project, index: true

      t.timestamps
    end
  end
end
