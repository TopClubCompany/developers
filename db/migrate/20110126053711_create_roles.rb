class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :role_type_id, :limit => 2, :default => 1
      t.references :user
      t.boolean :is_visible, :default => true, :null => false
      t.timestamps
    end
    add_index :roles, :user_id
  end
end
