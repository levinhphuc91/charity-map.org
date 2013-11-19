class CreateExtProjects < ActiveRecord::Migration
  def change
    create_table :ext_projects do |t|
      t.string :photo
      t.string :title
      t.string :location
      t.float :funding_goal
      t.integer :number_of_donors
      t.datetime :executed_at
      t.text :description
      t.references :user, index: true

      t.timestamps
    end
  end
end
