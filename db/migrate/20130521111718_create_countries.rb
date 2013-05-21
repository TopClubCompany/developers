class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :slug
      t.boolean :is_visible, default: true
      t.integer :position, default: 0

      t.timestamps
    end
    add_index :countries, :slug, :unique => true
  end
end
