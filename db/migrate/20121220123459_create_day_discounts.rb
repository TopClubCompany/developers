class CreateDayDiscounts < ActiveRecord::Migration
  def change
    create_table :day_discounts do |t|
      t.references :week_day
      t.time :from_time
      t.time :to_time
      t.float :discount

      t.timestamps
    end
    add_index :day_discounts, :week_day_id
  end
end
