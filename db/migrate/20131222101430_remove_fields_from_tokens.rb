class RemoveFieldsFromTokens < ActiveRecord::Migration
  def change
    remove_column :tokens, :created_for
    remove_column :tokens, :parent_id
    add_column :tokens, :ext_donation_id, :integer
  end
end
