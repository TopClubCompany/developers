class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :slug, :null => false
      t.references :user
      t.boolean :is_visible, :default => true, :null => false
      t.string     :phone
      t.string     :url
      t.integer    :avg_bill

      t.timestamps
    end
    add_index :places, :slug, :unique => true
    add_index :places, :user_id
  end
end
