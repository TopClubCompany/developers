class CreateDayDiscountSchedules < ActiveRecord::Migration
  def change
    create_table :day_discount_schedules do |t|
      t.references :place
      t.integer :day_type_id
      t.boolean :is_running, :default => true
      t.timestamps
    end
    add_index :day_discount_schedules, :place_id
    add_index :day_discount_schedules, :day_type_id
  end
end
