class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :category
      t.float :amount
      t.references :project, index: true
      t.string :in_words

      t.timestamps
    end
  end
end
