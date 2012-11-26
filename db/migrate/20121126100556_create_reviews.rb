class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :reviewable_id
      t.integer :food
      t.integer :service
      t.integer :pricing
      t.integer :ambiance




      t.string :reviewable_type
      t.string :title

      t.text :content

      t.references :user

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, [:reviewable_id, :reviewable_type]
  end
end
