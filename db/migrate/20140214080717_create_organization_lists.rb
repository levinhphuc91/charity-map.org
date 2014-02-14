class CreateOrganizationLists < ActiveRecord::Migration
  def change
    create_table :organization_lists do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :facebook
      t.text :address
      t.string :legal_entity
      t.string :geographical_area
      t.hstore :category
      t.string :year_of_establishment
      t.text :key_contact
      t.text :bank_account

      t.timestamps
    end
  end
end
