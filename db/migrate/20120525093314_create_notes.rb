class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :place
      t.string :picture
      t.string :title
      t.string :body

      t.timestamps
    end
  end
end
