class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :slug, :null => false
      t.boolean :is_visible, :default => true
      t.integer :position

      t.timestamps
    end
    add_index :cities, :slug, :unique => true
  end
end
