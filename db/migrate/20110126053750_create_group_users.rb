class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :group
      t.references :user
      t.boolean :is_chief, :default => false

      t.timestamps
    end
    add_index :group_users, :group_id
    add_index :group_users, :user_id
  end
end
