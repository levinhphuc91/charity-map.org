class AddAnonToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :anon, :boolean
  end
end
