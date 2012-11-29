class CreateMarkTypeGlob < ActiveRecord::Migration
  def up
    MarkType.create_translation_table! :name => :string, :description => :text
  end

  def down
    MarkType.drop_translation_table!
  end
end
