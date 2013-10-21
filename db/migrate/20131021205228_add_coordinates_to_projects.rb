class AddCoordinatesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :address, :string
    add_column :projects, :latitude, :float
    add_column :projects, :longitude, :float
  end
end
