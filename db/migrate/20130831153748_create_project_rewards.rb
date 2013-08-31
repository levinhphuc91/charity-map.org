class CreateProjectRewards < ActiveRecord::Migration
  def change
    create_table :project_rewards do |t|
      t.float :amount
      t.text :description
      t.references :project, index: true

      t.timestamps
    end
  end
end
