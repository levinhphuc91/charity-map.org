class AddExtraParamsToRedirectTokens < ActiveRecord::Migration
  def change
    add_column :redirect_tokens, :extra_params, :string
  end
end
