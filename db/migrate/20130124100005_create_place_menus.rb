class CreatePlaceMenus < ActiveRecord::Migration
  def change
    create_table :place_menus do |t|
      t.references :place

      t.timestamps
    end
    add_index :place_menus, :place_id
  end
end
