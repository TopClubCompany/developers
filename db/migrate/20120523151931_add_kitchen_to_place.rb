class AddKitchenToPlace < ActiveRecord::Migration
  def change
    change_table :places do |t|
      t.references :kitchen
    end
  end
end
