class AddAdminNoteToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :admin_note, :string
  end
end
