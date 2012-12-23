class CreateWeekDays < ActiveRecord::Migration
  def change
    create_table :week_days do |t|
      t.time :start_at,       default: nil
      t.time :end_at,         default: nil

      t.time :start_break_at, default: nil
      t.time :end_break_at,   default: nil

      t.integer :day_type_id, null: false

      t.boolean :is_working, default: false

      t.references :place
      t.timestamps
    end
    add_index :week_days, :place_id
    add_index :week_days, :day_type_id
  end
end
