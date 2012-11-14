class CreatePlaceAdministrators < ActiveRecord::Migration
  def change
    create_table :place_administrators do |t|
      t.references :place
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
    add_index :place_administrators, :place_id
  end
end
