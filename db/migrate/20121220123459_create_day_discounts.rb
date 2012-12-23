class CreateDayDiscounts < ActiveRecord::Migration
  def change
    create_table :day_discounts do |t|
      t.references :week_day
      t.decimal :from_time, precision: 4, scale:2,  default: nil
      t.decimal :to_time, precision: 4, scale:2,  default: nil
      t.float :discount

      t.timestamps
    end
    add_index :day_discounts, :week_day_id
  end
end
