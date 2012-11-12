class GroupFeatureGlob < ActiveRecord::Migration
  def up
    GroupFeature.create_translation_table! :name => :string, :description => :text
  end

  def down
    GroupFeature.drop_translation_table!
  end
end
