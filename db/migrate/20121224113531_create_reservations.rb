class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email

      t.text :special_notes

      t.datetime :time

      t.references :user
      t.references :place

      t.timestamps
    end
    add_index :reservations, :user_id
    add_index :reservations, :place_id
  end
end
