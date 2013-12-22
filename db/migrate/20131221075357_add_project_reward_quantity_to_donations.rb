class AddProjectRewardQuantityToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :project_reward_quantity, :integer
  end
end
