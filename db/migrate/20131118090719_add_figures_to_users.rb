class AddFiguresToUsers < ActiveRecord::Migration
  def change
    add_column :users, :figures, :hstore
  end
end
