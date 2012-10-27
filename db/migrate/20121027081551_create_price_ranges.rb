class CreatePriceRanges < ActiveRecord::Migration
  def change
    create_table :price_ranges do |t|
      t.float :min_price
      t.float :max_price
      t.float :avg_price
      t.references :place

      t.timestamps
    end
  end
end
