class AddCollectionTimeToExtDonations < ActiveRecord::Migration
  def change
    add_column :ext_donations, :collection_time, :datetime
  end
end
