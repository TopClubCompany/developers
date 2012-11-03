class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :locationable_id, :null => false
      t.string  :locationable_type, :limit => 50, :null => false
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.string :country
      t.float :distance

      t.timestamps
    end
    add_index :locations, [:locationable_id, :locationable_type]
  end
end
