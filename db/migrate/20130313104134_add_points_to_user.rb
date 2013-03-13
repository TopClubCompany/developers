class AddPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :points, :float, default: 0
  end
end
