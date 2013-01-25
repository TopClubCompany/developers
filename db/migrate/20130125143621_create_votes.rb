class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user
      t.references :review
      t.references :vote_type
      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :review_id
    add_index :votes, :vote_type_id
  end
end
