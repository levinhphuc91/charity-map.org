class CreateExtDonations < ActiveRecord::Migration
  def change
    create_table :ext_donations do |t|
      t.references :project, index: true
      t.float :amount
      t.text :note
      t.string :collection_method
      t.string :donor

      t.timestamps
    end
  end
end
