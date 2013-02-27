class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.integer :kind, :null => false
      t.boolean :is_visible, :default => true

      t.timestamps
    end
  end
end
