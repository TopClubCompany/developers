class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :group_type_id, :limit => 2, :default => 1
      t.references :user
      t.boolean :is_visible, :default => true, :null => false
      t.boolean :delta, :default => true, :null => false

      t.timestamps
    end
    add_index :groups, :user_id
  end
end
