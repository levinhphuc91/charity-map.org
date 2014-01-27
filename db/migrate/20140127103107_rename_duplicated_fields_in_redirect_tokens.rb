class RenameDuplicatedFieldsInRedirectTokens < ActiveRecord::Migration
  def change
    rename_column :redirect_tokens, :to_model, :redirect_class_name
    rename_column :redirect_tokens, :to_id, :redirect_class_id
  end
end
