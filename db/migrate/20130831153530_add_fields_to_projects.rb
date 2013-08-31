class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :start_date, :datetime
    add_column :projects, :end_date, :datetime
    add_column :projects, :funding_goal, :float
    add_column :projects, :location, :string
    add_column :projects, :thumbnail, :string
    add_reference :projects, :user, index: true
    add_column :projects, :status, :string
  end
end
