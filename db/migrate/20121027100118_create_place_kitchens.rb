class CreatePlaceKitchens < ActiveRecord::Migration
  def change
    create_table :place_kitchens do |t|
      t.references :place
      t.references :kitchen

      t.timestamps
    end
    add_index :place_kitchens, :place_id
    add_index :place_kitchens, :kitchen_id
  end

end
