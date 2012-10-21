class CreateAssetGlob < ActiveRecord::Migration
  def up
    Asset.create_translation_table! :name => :string, :description => :text
  end

  def down
    Asset.drop_translation_table!
  end
end
