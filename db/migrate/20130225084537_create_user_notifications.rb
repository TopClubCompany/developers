class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :position, default: 0
      t.boolean :is_visible, default: true

      t.timestamps
    end
  end
end
