class CreateKitchens < ActiveRecord::Migration
  def change
    create_table :kitchens do |t|
      t.string :slug, :null => false
      t.references :user
      t.boolean :is_visible, :default => true, :null => false

      t.timestamps
    end

    add_index :kitchens, :slug, :unique => true
    add_index :kitchens, :user_id
  end
end
