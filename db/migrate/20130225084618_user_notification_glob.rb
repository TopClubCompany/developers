class UserNotificationGlob < ActiveRecord::Migration
  def up
    UserNotification.create_translation_table! :title => :string, :description => :text
  end

  def down
    UserNotification.create_translation_table! :title => :string, :description => :text
  end
end
