class AddPhoneCodeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :phone_code_id, :integer
  end
end
