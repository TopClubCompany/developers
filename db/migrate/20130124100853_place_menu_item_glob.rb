class PlaceMenuItemGlob < ActiveRecord::Migration
  def up
    PlaceMenuItem.create_translation_table! :title => :string, :description => :text
  end

  def down
    PlaceMenuItem.drop_translation_table!
  end
end
