class CreatePlacesSelections < ActiveRecord::Migration
  def up
    create_table :places_selections, :id => false do |t|
      t.belongs_to :place, :selection
    end
  end

  def down
    drop_table :places_selections
  end
end