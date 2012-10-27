class CreatePlaceCategories < ActiveRecord::Migration
  def change
    create_table :place_categories do |t|
      t.references :category
      t.references :place

      t.timestamps
    end
    add_index :place_categories, :category_id
    add_index :place_categories, :place_id
  end

end
