class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :bio, :text
    add_column :users, :phone, :string
  end
end
