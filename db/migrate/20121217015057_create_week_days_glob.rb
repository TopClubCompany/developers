class CreateWeekDaysGlob < ActiveRecord::Migration
  def up
    WeekDay.create_translation_table! :title => :string
  end

  def down
    WeekDay.drop_translation_table!
  end
end
