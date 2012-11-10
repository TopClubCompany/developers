class CreateGlobLocation < ActiveRecord::Migration
  def up
    Location.create_translation_table! :street => :string, :city => :string, :country => :string, :county => :string
  end

  def down
    Location.drop_translation_table!
  end
end
