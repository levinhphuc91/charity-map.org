class CreateGiftCards < ActiveRecord::Migration
  def change
    create_table :gift_cards do |t|
      t.string :recipient_email
      t.float :amount
      t.hstore :references

      t.timestamps
    end
  end
end
