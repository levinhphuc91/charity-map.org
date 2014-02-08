class AddMasterTransactionIdToGiftCards < ActiveRecord::Migration
  def change
    add_column :gift_cards, :master_transaction_id, :string
  end
end
