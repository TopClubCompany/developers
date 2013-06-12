# -*- encoding : utf-8 -*-
class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.integer :actions_mask
      t.integer :context, :limit => 1, :default => 1
      t.integer :subject, :limit => 2, :default => 1
      t.integer :subject_id
      t.string :assoc
      t.string :assoc_ids
      t.boolean :is_visibility, :default => false
      t.boolean :is_own, :default => false
      t.boolean :is_work, :default => false
      t.references :role

      t.timestamps
    end
    add_index :permissions, :user_id
    add_index :permissions, [:subject, :subject_id]
  end
end
