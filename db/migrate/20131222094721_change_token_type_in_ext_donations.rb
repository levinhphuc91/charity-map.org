class ChangeTokenTypeInExtDonations < ActiveRecord::Migration
  def change
    change_column :ext_donations, :token, :string
  end
end
