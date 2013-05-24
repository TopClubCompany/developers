class CreateGroupRoles < ActiveRecord::Migration
  def change
    create_table :group_roles do |t|
      t.references :group
      t.references :role

      t.timestamps
    end
    add_index :group_roles, :group_id
    add_index :group_roles, :role_id
  end
end
