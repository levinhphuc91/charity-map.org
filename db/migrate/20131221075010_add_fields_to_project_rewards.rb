class AddFieldsToProjectRewards < ActiveRecord::Migration
  def change
    rename_column :project_rewards, :amount, :value
    add_column :project_rewards, :name, :string
    add_column :project_rewards, :photo, :string
    add_column :project_rewards, :quantity, :integer
  end
end
