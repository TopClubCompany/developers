class CreatePlaceMenuItems < ActiveRecord::Migration
  def change
    create_table :place_menu_items do |t|
      t.float :price, default: 0.00
      t.references :place_menu
      t.timestamps
    end
    add_index :place_menu_items, :place_menu_id
  end
end
