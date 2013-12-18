class AddShortCodeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :short_code, :string
  end
end
