class CreateGroupFeatureCategories < ActiveRecord::Migration
  def change
    create_table :group_feature_categories do |t|
      t.references :group_feature
      t.references :category

      t.timestamps
    end
    add_index :group_feature_categories, :group_feature_id
    add_index :group_feature_categories, :category_id
  end
end
