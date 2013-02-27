class LetterGlob < ActiveRecord::Migration
  def up
    Letter.create_translation_table! topic: :string, content: :text
  end

  def down
    Letter.drop_translation_table!
  end
end
