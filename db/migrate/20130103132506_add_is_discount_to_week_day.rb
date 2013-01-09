class AddIsDiscountToWeekDay < ActiveRecord::Migration
  def change
    add_column :day_discounts, :is_discount, :boolean
  end
end
