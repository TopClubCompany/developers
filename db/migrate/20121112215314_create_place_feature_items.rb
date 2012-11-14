class CreatePlaceFeatureItems < ActiveRecord::Migration
  def change
    create_table :place_feature_items do |t|
      t.references :place
      t.references :feature_item

      t.timestamps
    end
    add_index :place_feature_items, :place_id
    add_index :place_feature_items, :feature_item_id
  end
end
