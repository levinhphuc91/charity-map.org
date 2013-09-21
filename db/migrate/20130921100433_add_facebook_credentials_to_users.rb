class AddFacebookCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_credentials, :hstore
  end
end
