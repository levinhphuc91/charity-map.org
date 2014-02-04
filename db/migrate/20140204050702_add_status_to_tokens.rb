class AddStatusToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :status, :string
  end
end
