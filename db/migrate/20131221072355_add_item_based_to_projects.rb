class AddItemBasedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :item_based, :boolean
  end
end
