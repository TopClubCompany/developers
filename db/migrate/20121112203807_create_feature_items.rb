class CreateFeatureItems < ActiveRecord::Migration
  def change
    create_table :feature_items do |t|
      t.boolean :is_visible, :default => true
      t.references :group_feature

      t.timestamps
    end
    add_index :feature_items, :group_feature_id
  end
end
