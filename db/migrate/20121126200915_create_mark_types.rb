class CreateMarkTypes < ActiveRecord::Migration
  def change
    create_table :mark_types do |t|

      t.timestamps
    end
  end
end
