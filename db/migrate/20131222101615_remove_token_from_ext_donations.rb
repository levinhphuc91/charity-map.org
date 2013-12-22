class RemoveTokenFromExtDonations < ActiveRecord::Migration
  def change
    remove_column :ext_donations, :token
  end
end
