class CreateWeekDays < ActiveRecord::Migration
  def change
    create_table :week_days do |t|
      t.float :start_at,       default: nil
      t.float :end_at,         default: nil

      t.float :start_break_at, default: nil
      t.float :end_break_at,   default: nil


      t.references :place
      t.timestamps
    end
    add_index :week_days, :place_id
  end
end
