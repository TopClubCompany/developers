class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.integer :value
      t.references :mark_type
      t.references :review

      t.timestamps
    end

    add_index :marks, :review_id
    add_index :marks, :mark_type_id
  end
end
