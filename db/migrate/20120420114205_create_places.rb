class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :category
      t.string     :name
      t.text       :description
      t.text       :address
      t.float      :lat
      t.float      :lng
      t.string     :phone
      t.string     :url

      t.timestamps
    end
    add_index :places, :category_id
  end
end
