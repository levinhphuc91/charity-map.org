class AddStatusToGiftCards < ActiveRecord::Migration
  def change
    add_column :gift_cards, :status, :string
  end
end
