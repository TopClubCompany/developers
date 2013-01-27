class CreateUserFavoritePlaces < ActiveRecord::Migration
  def change
    create_table :user_favorite_places do |t|
      t.references :user
      t.references :place
      t.timestamps
    end
    add_index :user_favorite_places, :user_id
    add_index :user_favorite_places, :place_id
  end
end
