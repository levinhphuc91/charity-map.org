class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.text :content

      t.timestamps
    end
  end
end
