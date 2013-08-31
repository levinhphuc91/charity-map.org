class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :euid
      t.string :status
      t.references :user, index: true
      t.float :amount
      t.text :note
      t.string :collection_method
      t.references :project_reward, index: true
      t.references :project, index: true

      t.timestamps
    end
  end
end
