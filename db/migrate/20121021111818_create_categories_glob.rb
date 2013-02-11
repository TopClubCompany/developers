class CreateCategoriesGlob < ActiveRecord::Migration
  def up
    Category.create_translation_table! :name => :string, :description => :text, :plural_name => :string
  end

  def down
    Category.drop_translation_table!
  end
end
