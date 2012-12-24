class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.text :special_notes

      t.timestamps
    end
  end
end
