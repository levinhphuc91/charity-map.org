class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :value
      t.string :created_for
      t.integer :parent_id

      t.timestamps
    end
  end
end
