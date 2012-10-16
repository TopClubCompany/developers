class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :place
      t.string :body

      t.timestamps
    end
    add_index :reviews, :user_id
  end
end
