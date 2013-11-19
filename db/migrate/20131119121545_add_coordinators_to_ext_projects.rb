class AddCoordinatorsToExtProjects < ActiveRecord::Migration
  def change
    add_column :ext_projects, :address, :string
    add_column :ext_projects, :latitude, :float
    add_column :ext_projects, :longitude, :float
  end
end
