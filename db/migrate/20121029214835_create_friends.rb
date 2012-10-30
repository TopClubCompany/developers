class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :social_id, :null => false
      t.string :name
      t.string :type

      t.references :user

      t.timestamps
    end
    add_index :friends, :user_id
    add_index :friends, :social_id
  end
end
