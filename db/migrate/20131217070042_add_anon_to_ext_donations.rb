class AddAnonToExtDonations < ActiveRecord::Migration
  def change
    add_column :ext_donations, :anon, :boolean
  end
end
