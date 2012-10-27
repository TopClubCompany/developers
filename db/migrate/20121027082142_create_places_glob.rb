class CreatePlacesGlob < ActiveRecord::Migration
  def up
    Place.create_translation_table! :name => :string, :description => :text, :address => :text
  end

  def down
    Place.drop_translation_table!
  end
end
