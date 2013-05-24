class AddPermsGlob < ActiveRecord::Migration
  def self.up
    Role.create_translation_table! :name => :string, :description => :text
  end

  def self.down
    Role.drop_translation_table!
  end
end
