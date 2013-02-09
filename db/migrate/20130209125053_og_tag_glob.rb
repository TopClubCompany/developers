class OgTagGlob < ActiveRecord::Migration
  def up
    OgTag.create_translation_table! :title => :string, :description => :text, :url => :string, :image => :string, :site_name => :string
  end

  def down
    OgTag.drop_translation_table!
  end
end
