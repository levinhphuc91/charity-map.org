class AddUserIdToGiftCards < ActiveRecord::Migration
  def change
    add_column :gift_cards, :user_id, :integer
  end
end
