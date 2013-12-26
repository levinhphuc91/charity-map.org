class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.float :amount

      t.timestamps
    end
  end
end
