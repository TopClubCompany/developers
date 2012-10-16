class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string :picture
      t.references :user
      t.string :kind
      t.string :description

      t.timestamps
    end
    add_index :selections, :user_id
  end
end
