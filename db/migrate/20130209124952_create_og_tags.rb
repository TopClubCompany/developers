class CreateOgTags < ActiveRecord::Migration
  def change
    create_table :og_tags do |t|
      t.string :og_type
      t.references :header

      t.timestamps
    end

    add_index :og_tags, :header_id
  end
end
