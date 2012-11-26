class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.integer :food
      t.integer :service
      t.integer :pricing
      t.integer :ambiance
      t.references :review

      t.timestamps
    end
    add_index :marks, :food
    add_index :marks, :service
    add_index :marks, :pricing
    add_index :marks, :ambiance
    add_index :marks, :review_id
  end
end
