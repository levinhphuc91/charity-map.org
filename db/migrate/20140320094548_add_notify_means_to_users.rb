class AddNotifyMeansToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_via_email, :boolean
    add_column :users, :notify_via_sms, :boolean
    add_column :users, :notify_via_facebook, :boolean
  end
end
