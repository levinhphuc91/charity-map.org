class AddReceiptToVerifications < ActiveRecord::Migration
  def change
    add_column :verifications, :receipt, :hstore
  end
end
