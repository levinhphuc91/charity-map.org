class AddOrgToUsers < ActiveRecord::Migration
  def change
    add_column :users, :org, :boolean
  end
end
