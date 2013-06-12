class CreateCountryGlob < ActiveRecord::Migration
  def up
    Country.create_translation_table! title: :string, description: :text
  end

  def down
    Country.drop_translation_table!
  end
end
