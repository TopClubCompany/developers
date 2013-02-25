class CreateUUserNotifications < ActiveRecord::Migration
  def change
    create_table :u_user_notifications do |t|
      t.references :user
      t.references :user_notification

      t.timestamps
    end
    add_index :u_user_notifications, [:user_notification_id, :user_id]
  end
end
