class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_at
      t.string   :picture
      t.string   :kind
      t.string   :title
      t.references :place

      t.timestamps
    end
    add_index :events, :place_id
  end
end
