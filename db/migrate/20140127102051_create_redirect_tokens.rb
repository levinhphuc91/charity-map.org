class CreateRedirectTokens < ActiveRecord::Migration
  def change
    create_table :redirect_tokens do |t|
      t.string :value
      t.string :to_model
      t.string :to_id

      t.timestamps
    end
  end
end
