class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.boolean :is_visible, default: true
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
