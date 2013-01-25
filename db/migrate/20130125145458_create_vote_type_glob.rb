class CreateVoteTypeGlob < ActiveRecord::Migration
  def up
    VoteType.create_translation_table! title: :string, description: :text
  end

  def down
    VoteType.drop_translation_table!
  end
end
