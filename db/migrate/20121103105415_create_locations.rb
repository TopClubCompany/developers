class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :locationable_id, :null => false
      t.string  :locationable_type, :limit => 50, :null => false
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.float :distance
      t.string :house_number
      t.string :country_code

      t.timestamps
    end
    add_index :locations, [:locationable_id, :locationable_type]
  end
end
