class AddShippingFeeAppliedToProjectRewards < ActiveRecord::Migration
  def change
    add_column :project_rewards, :shipping_fee_applied, :boolean
  end
end
