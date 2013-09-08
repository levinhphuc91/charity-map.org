class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.string :code
      t.references :user, index: true
      t.string :channel
      t.string :status

      t.timestamps
    end
  end
end
