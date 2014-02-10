class AddTokenToGiftCards < ActiveRecord::Migration
  def change
    add_column :gift_cards, :token, :string
  end
end
