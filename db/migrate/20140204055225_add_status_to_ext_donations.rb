class AddStatusToExtDonations < ActiveRecord::Migration
  def change
    add_column :ext_donations, :status, :string
  end
end
