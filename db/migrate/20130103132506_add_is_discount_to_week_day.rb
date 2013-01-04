class AddIsDiscountToWeekDay < ActiveRecord::Migration
  def change
    add_column :week_days, :is_discount, :boolean
  end
end
