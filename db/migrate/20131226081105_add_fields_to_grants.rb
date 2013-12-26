class AddFieldsToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :name, :string
    add_column :grants, :giver, :string
  end
end
