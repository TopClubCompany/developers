class AddIsSmsSendToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_sms_send, :boolean, :default => false
  end
end
