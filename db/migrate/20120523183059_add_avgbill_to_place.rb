class AddAvgbillToPlace < ActiveRecord::Migration
  def change
    add_column :places, :avgbill, :integer

  end
end
