class CreateFeatureItemGlob < ActiveRecord::Migration
  def up
    FeatureItem.create_translation_table! :name => :string
  end

  def down
    FeatureItem.drop_translation_table!
  end
end
