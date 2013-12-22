class RenameTokenIdInExtDonations < ActiveRecord::Migration
  def change
    rename_column :ext_donations, :token_id, :token
  end
end
