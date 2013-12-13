class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
