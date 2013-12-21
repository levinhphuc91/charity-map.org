class AddTokenIdToExtDonations < ActiveRecord::Migration
  def change
    add_column :ext_donations, :token_id, :integer
    remove_column :donations, :token_id
  end
end
