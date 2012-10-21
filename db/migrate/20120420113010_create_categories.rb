class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :slug, :null => false
      t.references :user
      t.boolean :is_visible, :default => true, :null => false

      t.integer "parent_id"
      t.integer "lft", :default => 0
      t.integer "rgt", :default => 0
      t.integer "depth", :default => 0
      t.timestamps
    end

    add_index :categories, :slug, :unique => true
    add_index :categories, :user_id
    add_index :categories, :parent_id
    add_index :categories, [:lft, :rgt]

  end
end
