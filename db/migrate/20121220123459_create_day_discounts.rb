class CreateDayDiscounts < ActiveRecord::Migration
  def change
    create_table :day_discounts do |t|
      t.references :day_discount_schedule
      t.time :from_time
      t.time :to_time
      t.float :discount

      t.timestamps
    end
  end
end
