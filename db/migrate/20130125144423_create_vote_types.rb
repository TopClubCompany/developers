class CreateVoteTypes < ActiveRecord::Migration
  def change
    create_table :vote_types do |t|

      t.timestamps
    end
  end
end
