class AddPersonsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :persons, :integer
  end
end
