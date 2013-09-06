class AddVerifiedByPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :verified_by_phone, :boolean
  end
end
