class CreateGlobDayDiscountsGlob < ActiveRecord::Migration
  def up
    DayDiscount.create_translation_table! :title => :string, :description => :text
  end

  def down
    DayDiscount.drop_translation_table!
  end
end
