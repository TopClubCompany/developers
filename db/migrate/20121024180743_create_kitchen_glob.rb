class CreateKitchenGlob < ActiveRecord::Migration
  def up
    Kitchen.create_translation_table! :name => :string, :description => :text
  end

  def down
    Kitchen.drop_translation_table!
  end
end
