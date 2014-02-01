class CreateCityGlob < ActiveRecord::Migration
  def up
    City.create_translation_table! :name => :string, :description => :text, :plural_name => :string, :letter => :text
  end

  def down
    City.drop_translation_table!
  end
end
