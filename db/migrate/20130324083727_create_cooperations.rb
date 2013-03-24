class CreateCooperations < ActiveRecord::Migration
  def change
    create_table :cooperations do |t|
      t.string :email #, :null => false
      t.string :name
      t.string :phone
      t.string :place_name
      t.string :city
      t.timestamps
    end
  end
end
