# -*- encoding : utf-8 -*-
class CreateHeaders < ActiveRecord::Migration
  def self.up
    create_table :headers do |t|
      
      t.string    :headerable_type, :limit => 30, :null => false
      t.integer   :headerable_id, :null => false
      t.integer :tag_type_id, :null => false
      
      t.timestamps
    end
    
    add_index :headers, [:headerable_type, :headerable_id]
    add_index :headers, :tag_type_id
  end

  def self.down
    drop_table :headers
  end
end
