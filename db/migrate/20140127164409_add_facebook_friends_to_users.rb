class AddFacebookFriendsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_friends, :hstore
  end
end
