class PlaceMenuGlob < ActiveRecord::Migration
  def up
    PlaceMenu.create_translation_table! :title => :string, :description => :text
  end

  def down
    PlaceMenu.create_translation_table! :title => :string, :description => :text
  end
end
