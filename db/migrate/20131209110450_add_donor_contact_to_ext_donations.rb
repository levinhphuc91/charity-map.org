class AddDonorContactToExtDonations < ActiveRecord::Migration
  def change
    add_column :ext_donations, :email, :string
    add_column :ext_donations, :phone, :string
  end
end
