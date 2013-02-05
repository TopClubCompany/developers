class CreateMainSliders < ActiveRecord::Migration
  def change
    create_table :main_sliders do |t|
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
